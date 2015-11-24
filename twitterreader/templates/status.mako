<%inherit file="site.mako"/>
<%namespace name="print_tweet" file="tweet.mako"/>
<div class="row">
${print_tweet.print_tweet(status, class_bootstrap="col-md-10")}
</div>
<div class="row">
% for reply in replies:
    ${print_tweet.print_tweet(reply, class_bootstrap="col-md-10")}
% endfor
</div>
