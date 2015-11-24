from pyramid.config import Configurator
from sqlalchemy import engine_from_config
import views
from .models import (
    DBSession,
    Base,
)
from pyramid.session import SignedCookieSessionFactory


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    engine = engine_from_config(settings, 'sqlalchemy.')
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    session_factory = SignedCookieSessionFactory('supersecret', timeout=86400)
    config = Configurator(settings=settings)
    config.set_session_factory(session_factory)
    config.include('pyramid_chameleon')
    config.include('pyramid_mako')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/welcome')
    config.add_route('view_user_timeline', '/user/{screen_name}')
    config.add_route('view_status', '/status/{screen_name}/{tweet_id}')
    config.add_route('oauth_user', '/oauth_user')
    config.add_route('my_timeline', '/')
    config.add_route('cookie_delete', '/cookie')
    config.add_route('search', '/search')
    config.add_route('theme', '/theme')
    config.add_view(views.theme, route_name='theme')
    config.scan()
    return config.make_wsgi_app()
