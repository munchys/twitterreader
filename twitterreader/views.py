from pyramid.response import Response
from pyramid.view import view_config
from pyramid.httpexceptions import (
    HTTPFound,
    HTTPServiceUnavailable,
)
from requests_oauthlib import OAuth1Session
import twitter
from utilities import(
    get_screen_name,
)


@view_config(route_name='cookie_delete', renderer='templates/tweets.mako')
def delete_cookie_view(request):
    request.session.invalidate()
    return HTTPFound(location=request.route_url('home'))


@view_config(route_name='home', renderer='templates/welcome.mako')
def home_view(request):
    screen_name, name, profile_image_url = get_screen_name(request.session)
    return dict(
        screen_name=screen_name,
        name=name,
        profile_image_url=profile_image_url,
    )


@view_config(route_name='oauth_user', renderer='templates/tweets.mako')
def oauth_user(request):
    """
    used to authenticate the user
    tokens are stored in session
    if the cookie is deleted the user will have
    to authenticate again
    """
    settings = request.registry.settings
    session = request.session
    if 'oauth_token_secret' not in session:
        oauth_client = OAuth1Session(
            settings['consumer_key'],
            client_secret=settings['consumer_secret'],
            callback_uri=request.route_url('oauth_user')
        )
        try:
            resp = oauth_client.fetch_request_token('https://api.twitter.com/oauth/request_token')
        except Exception, e:
            print "WTF ?", type(e)
            return HTTPServiceUnavailable("WTF ?")
        url = oauth_client.authorization_url('https://api.twitter.com/oauth/authorize')
        session['oauth_token_secret'] = resp['oauth_token_secret']
        return HTTPFound(location=url)

    if 'denied' in request.params:
        session.invalidate()
        return HTTPFound(location=request.route_url('home'))

    if session.get('authenticated') is not True:
        if 'oauth_token' not in request.params:
            session.invalidate()
            return HTTPFound(location=request.route_url('oauth_user'))
        oauth_client_permanent = OAuth1Session(
            settings['consumer_key'],
            client_secret=settings['consumer_secret'],
            resource_owner_key=request.params['oauth_token'],
            resource_owner_secret=session['oauth_token_secret'],
            verifier=request.params['oauth_verifier']
        )
        try:
            resp = oauth_client_permanent.fetch_access_token('https://api.twitter.com/oauth/access_token')
        except Exception, e:
            print "WTF ?", type(e)
            return HTTPServiceUnavailable("WTF ?")
        session['oauth_token_secret'] = resp.get('oauth_token_secret')
        session['oauth_token'] = resp.get('oauth_token')
        session['authenticated'] = True
    return HTTPFound(location=request.route_url('my_timeline'))


@view_config(route_name='search', renderer='templates/search.mako')
def search_view(request):
    session = request.session
    settings = request.registry.settings
    number_tweet = settings.get('tweets_per_request')
    if not session.get('authenticated'):
        session.invalidate()
        return HTTPFound(location=request.route_url('oauth_user'))
    if request.params.get('q') == '':
        initial_query = None
    else:
        initial_query = request.params.get('q')
    api = twitter.Api(
        consumer_key=settings['consumer_key'],
        consumer_secret=settings['consumer_secret'],
        access_token_key=session['oauth_token'],
        access_token_secret=session['oauth_token_secret'],
    )
    try:
        search_result = api.GetSearch(term=initial_query, count=number_tweet)
    except twitter.TwitterError, e:
        print(e)
        return HTTPServiceUnavailable("WTF ?")
    screen_name, name, profile_image_url = get_screen_name(request.session)
    return dict(
        tweets=search_result,
        q=initial_query,
        screen_name=screen_name,
        name=name,
        profile_image_url=profile_image_url,
    )


@view_config(route_name='my_timeline', renderer='templates/my_timeline.mako')
def my_timeline_view(request):
    """
    function to get the authenticated user home timeline
    """
    session = request.session
    settings = request.registry.settings
    number_tweet = settings.get('tweets_per_request')
    if not session.get('authenticated'):
        return HTTPFound(location=request.route_url('home'))
    api = twitter.Api(
        consumer_key=settings['consumer_key'],
        consumer_secret=settings['consumer_secret'],
        access_token_key=session['oauth_token'],
        access_token_secret=session['oauth_token_secret'],
    )
    try:
        usertimeline = api.GetHomeTimeline(count=number_tweet)
    except twitter.TwitterError, e:
        print("Error with app.twitter.com config", e)
        return HTTPServiceUnavailable("WTF ?")

    if not (session.get('screen_name')):
        # from pprint import pprint
        # pprint(api.VerifyCredentials().__dict__)
        verifie = api.VerifyCredentials()
        session['screen_name'] = '@{}'.format(verifie.screen_name)
        session['name'] = verifie.name.encode('utf8')
        session['profile_image_url'] = verifie.profile_image_url
    screen_name, name, profile_image_url = get_screen_name(request.session)
    return dict(
        tweets=usertimeline,
        screen_name=screen_name,
        name=name,
        profile_image_url=profile_image_url,
    )


def theme(request):
    session = request.session
    session['theme'] = request.params['theme']
    return Response(session['theme'])


@view_config(route_name='view_user_timeline', renderer='templates/user.mako')
def user_timeline_view(request):
    session = request.session
    settings = request.registry.settings
    number_tweet = settings.get('tweets_per_request')
    if not session.get('authenticated'):
        session.invalidate()
        return HTTPFound(location=request.route_url('oauth_user'))
    api = twitter.Api(
        consumer_key=settings['consumer_key'],
        consumer_secret=settings['consumer_secret'],
        access_token_key=session['oauth_token'],
        access_token_secret=session['oauth_token_secret'],
    )
    try:
        usertimeline = api.GetUserTimeline(screen_name=request.matchdict.get("screen_name"), count=number_tweet)
    except twitter.TwitterError, e:
        print(e)
        return HTTPServiceUnavailable("WTF ?")
    if usertimeline:
        user = usertimeline[0].user
    else:
        user = api.GetUser(screen_name=request.matchdict.get("screen_name"))
    screen_name, name, profile_image_url = get_screen_name(request.session)
    return dict(
        tweets=usertimeline,
        user=user,
        screen_name=screen_name,
        name=name,
        profile_image_url=profile_image_url
    )


@view_config(route_name='view_status', renderer='templates/status.mako')
def status_view(request):
    session = request.session
    settings = request.registry.settings
    number_tweet = settings.get('tweets_per_request')
    replies = list()
    if not session.get('authenticated'):
        session.invalidate()
        return HTTPFound(location=request.route_url('oauth_user'))
    api = twitter.Api(
        consumer_key=settings['consumer_key'],
        consumer_secret=settings['consumer_secret'],
        access_token_key=session['oauth_token'],
        access_token_secret=session['oauth_token_secret'],
    )
    try:
        # from pprint import pprint
        tweet_id = request.matchdict.get("tweet_id")
        screen_name = request.matchdict.get("screen_name")
        status = api.GetStatus(tweet_id)

        search_by_screen_name = api.GetSearch(term=screen_name, count=number_tweet)
        count = 0
        for result_by_screen_name in search_by_screen_name:
            if str(result_by_screen_name.in_reply_to_status_id) == str(tweet_id):
                replies.append(api.GetStatus(result_by_screen_name.id))
                count += 1
                if count > 10:
                    break
    except twitter.TwitterError, e:
        print(e)
        return HTTPServiceUnavailable("WTF ?")
    # user = status[0].user
    screen_name, name, profile_image_url = get_screen_name(request.session)
    # pprint(replies)
    return dict(
        replies=replies,
        status=status,
        # user=user,
        screen_name=screen_name,
        name=name,
        profile_image_url=profile_image_url
    )
