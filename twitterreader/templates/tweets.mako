
<%namespace name="print_tweet" file="tweet.mako"/>
<div class="row">
% for count, tweet in enumerate(tweets):
    ${print_tweet.print_tweet(tweet)}
    % if (count+1)%4 == 0 :
        </div>
        <hr>
        <div class="row">
    %endif
%endfor
</div>
