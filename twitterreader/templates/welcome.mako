<%inherit file="site.mako"/>
<div class="row">
    <div class="jumbotron">
        <h1>Welcome to Twitter Reader</h1>
        <p>
        This app will allow you to view your twitter timeline.
        To begin click the start button below. </p>
        <a class="btn btn-primary btn-lg" href="${request.route_url('oauth_user')}" role="button">start</a></p>
    </div>
</div>
