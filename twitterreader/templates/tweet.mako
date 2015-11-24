<%!import twitterreader.utilities as util %>

<%def name='print_tweet(tweet, class_bootstrap="col-md-3")'>
    % if tweet.retweeted_status :
        <% tweet.text =  u'RT @{} : {}'.format(tweet.retweeted_status.user.screen_name, tweet.retweeted_status.text) %>
    %endif
    <% tweet.text = util.make_text_displayable(tweet.text ,request.route_url('search'),
    request.route_url('view_user_timeline', screen_name='')) %>
    <div class="${class_bootstrap} tweet_div" id="id_${tweet.id}"><br>
        <a target="_blank" href="https://twitter.com/${tweet.user.screen_name}">
            <img src="${tweet.user.profile_image_url}" alt="user profile image"class="profile_img">
        </a>
        <br>
        <span>${tweet.GetRelativeCreatedAt()}</span>
        <h3> ${tweet.user.name}</h3>
        <a href="${request.route_url('view_user_timeline', screen_name=tweet.user.screen_name)}"><h4>@${tweet.user.screen_name}</h4></a>
        <p>${tweet.text| n}</p>
        %  if tweet.media :
            % for img in tweet.media :
                <a class="thumbnail" target="_blank" href=${img['media_url']} ><img class="media-object twitter_image" src="${img['media_url']}"
                alt="embedded image"></a>
            % endfor
        % endif
        <br>
        <p>
            % if tweet._in_reply_to_status_id:
                <em>
                    <a href="${request.route_url('view_status', screen_name=tweet.in_reply_to_screen_name, tweet_id=tweet.in_reply_to_status_id)}">In reply to</a>
                    <strong><a href="${request.route_url('view_user_timeline', screen_name=tweet.in_reply_to_screen_name)}">@${tweet.in_reply_to_screen_name}</a></strong>
                </em>
                <br>
            % endif
            <a class=info href="${request.route_url('view_status', screen_name=tweet.user.screen_name, tweet_id=tweet.id)}" alt="See it">
                <span class="glyphicon glyphicon-arrow-right"></span><span class="info">see the replies(if any) </span>
            </a>
            <a class=info target="_blank" href="https://twitter.com/${tweet.user.screen_name}/status/${tweet.id}" alt="See on Twitter">
                <span class="glyphicon glyphicon-link"></span><span class="info">see this tweet on twitter</span>
            </a>
            </a>
        </p>
    </div>
</%def>
