<%inherit file="site.mako"/>
<%!import twitterreader.utilities as util %>

<div class="row">
    <!-- USER PROFILE  -->
    <% description = util.make_text_displayable(user.GetDescription() ,request.route_url('search'),
    request.route_url('view_user_timeline', screen_name='')) %>
    <div class="row">
        <div class="jumbotron" >
          % if user.profile_banner_url:
            <div class="thumbnail bg-img">
                <img class="banner_img" src="${user.profile_banner_url}/1500x500" alt=""></img>
            </div>
          %endif
            <div class="container-fluid">
                <h2>${user.name}</h1>
                <% profile_img = util.change_image_profile_size_url(user.profile_image_url, '200x200')%>
                <img src="${profile_img}" alt="user profile image" class="user_profile_img">

                <h2>@${user.screen_name}</h2>
                <p>${description| n}<br>
              % if user.GetUrl() :
                <a href="${user.GetUrl()}">${user.GetUrl()}</a><br>
              %endif

                </p>
                <span class="glyphicon glyphicon-star"> favoris : ${user.GetFavouritesCount()}</span><br>
                <span class="glyphicon glyphicon-user"> followers : ${user.GetFollowersCount()}</span><br>
                <span class="glyphicon glyphicon-info-sign"> statuses : ${user.GetStatusesCount()}</span><br>
                <span class="glyphicon glyphicon-link"> link : <a href="https://twitter.com/${user.screen_name}">${user.screen_name}</a></span>
            </div>
        </div>
    </div>
</div>

<%include file="tweets.mako"/>
