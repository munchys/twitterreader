import re


def get_screen_name(session):
    if session.get('screen_name'):
        screen_name = session['screen_name']
        name = session['name'].decode('utf-8')
        profile_image_url = session['profile_image_url']
    else:
        screen_name = None
        name = None
        profile_image_url = None
    return screen_name, name, profile_image_url


def make_text_displayable(text, search_url, user_url):
    text_links = make_urls_links(text)
    text_hashtags = make_hashtags_links(text_links, search_url)
    text_all = make_usermentions_links(text_hashtags, user_url)
    return text_all


# change size of the profile pic only 200x200, 400x400, mini and bigger seem to work
def change_image_profile_size_url(img_url, size_string):
    biggerimage = re.sub(r'normal',
                         size_string,
                         img_url)
    return biggerimage


def make_hashtags_links(text, url):
    hashtag_mention = re.compile(ur'#([\w]+)', re.UNICODE)
    modifiedtext = hashtag_mention.sub(ur' <a  href="{}?q=%23\1">#\1</a>'.format(url),
                                       text)
    return modifiedtext


def make_usermentions_links(text, url):
    screen_name_mention = re.compile(ur'@([\w]+)', re.UNICODE)
    modifiedtext = screen_name_mention.sub(ur' <a href="{}\1">@\1</a>'.format(url),
                                           text)
    return modifiedtext


def make_urls_links(text):
    modifiedtext = re.sub(r'(https?://[^\s]+|//[^\s]+|\\\\[^\s,.]+)',
                          r'<a target="_blank" href="\1">\1</a>',
                          text)
    return modifiedtext
