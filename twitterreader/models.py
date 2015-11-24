from sqlalchemy import (
    Column,
    Index,
    Integer,
    Unicode,
)

from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
)

from zope.sqlalchemy import ZopeTransactionExtension

DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))
Base = declarative_base()


class Rss(Base):
    __tablename__ = 'rss'
    rss_id = Column(Integer, primary_key=True)
    rss_name = Column(Unicode(255))
    rss_url = Column(Unicode(255), nullable=False)


class User(Base):
    __tablename__ = 'user'
    user_id = Column(Integer, primary_key=True)
    user_name = Column(Unicode(255), unique=True)
    user_token = Column(Unicode(255))
    user_token_secret = Column(Unicode(255))
    user_theme = Column(Unicode(10))
