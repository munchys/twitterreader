<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang=""> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" lang=""> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9" lang=""> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang=""> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>twitter-reader</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="apple-touch-icon" href="apple-touch-icon.png">
    <link rel="icon" href="${request.static_url('twitterreader:static/munch.ico')}">
    <link rel="stylesheet" href="${request.static_url('twitterreader:static/css/bootstrap.min.css')}">
    <style>
        body {
        padding-top: 50px;
        padding-bottom: 20px;
        }
    </style>
    <link rel="stylesheet" href="${request.static_url('twitterreader:static/css/bootstrap-theme.min.css')}">
    <script src="${request.static_url('twitterreader:static/js/vendor/modernizr-2.8.3-respond-1.4.2.min.js')}"></script>
    <link rel="stylesheet" href="${request.static_url('twitterreader:static/css/main.css')}">
    % if request.session.get('theme') == 'dark':
        <link rel="stylesheet" href="${request.static_url('twitterreader:static/css/main-dark.css')}">
    % endif
</head>
<body>
  <!--[if lt IE 8]>
  <p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
  <![endif]-->
% if not request.url == request.route_url('home'):
  <%block name="navigation">

<nav class="navbar
% if request.session.get('theme') == 'dark':
navbar-inverse
% else :
navbar-default
%endif
navbar-fixed-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" accesskey="h" href="${request.application_url}">twitter-reader</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">
                <li>
                    <a href="${request.route_url('cookie_delete')}" accesskey="d" >disconnect</a>
                </li>
                <li id="theme">
                    <a href="#">switch theme</a>
                </li>
            </ul>
            <ul class="nav navbar-nav">
                <li
                    % if request.url== request.route_url('my_timeline'):
                        class="active"
                    % endif
                    >
                    <a  href="https://twitter.com/${screen_name}" alt="${screen_name}" target="_blank" accesskey="p" ><img id="mini_profile_image_url"src="${profile_image_url}"/>${name}</a>
                </li>
            </ul>
            <form class="navbar-form navbar-left" role="search" method="get" action="${request.route_url('search')}">
                <div class="form-group">
                    <input type="text" name="q" placeholder="search tweets" class="form-control"
                    % if not q :
                    value = ""
                    % else:
                    value = "${q}"
                    % endif
                    >
                </div>
                <button type="submit" class="btn btn-success" >Go</button>
            </form>
        </div>
        <!-- <div id="navbar" class="navbar-collapse collapse navbar-fixed-top navbar-right">
        </div> -->
        <!-- /.navbar-collapse -->
    </div>
</nav>
    </%block>
%endif
<div class="container">

${self.body()}

</div>
<!-- <footer>
<p>&copy; Company 2015</p>
</footer> -->
<!-- /container -->
<%block name="footer">
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')</script>

<script src="${request.static_url('twitterreader:static/js/vendor/bootstrap.min.js')}"></script>

<script src="${request.static_url('twitterreader:static/js/plugins.js')}"></script>
<script src="${request.static_url('twitterreader:static/js/main.js')}"></script>
<script src="${request.static_url('twitterreader:static/js/js.cookie.js')}"></script>
<script>


$(document).ready(function(){
  % if request.session.get('theme'):
    Cookies.set('theme', '${request.session.get('theme')}', { expires: 7, path: '/' });
  % else :
    Cookies.set('theme', 'bright', { expires: 7, path: '/' });
  % endif

  $("#theme").click(function(event){
    event.preventDefault();

    if (Cookies.get('theme')== "bright"){
      Cookies.set('theme', 'dark', { expires: 7, path: '/' });
      $('body').css({"background-color":"#303030"});
      $('p,.container-fluid>p,.col-md-10>p,.col-md-3>p,span,h3,h2,h1').css({"color":"#B5B5B5"});
      $('span.info,.col-md-10,.col-md-3,.jumbotron').css({"background-color": "#212121", "border": "1px solid #555555"});
      $('em>a,.col-md-10>a,.col-md-3>a,p>a,a>h4').css({"color":"#85C2FF"});
      $('.thumbnail').css({"background-color":"#191919"})
      $('nav').removeClass("navbar-default").addClass("navbar-inverse");
      $.ajax({
              url: "${request.route_url('theme')}?theme="+Cookies.get('theme'),
              type: "GET",
              dataType: "html"
          });
      return
    }
    if (Cookies.get('theme')== "dark"){
      Cookies.set('theme', 'bright', { expires: 7, path: '/' });
      $('body').css({"background-color":"rgb(173, 216, 230)"});
      $('span.info,.col-md-10,.col-md-3,.jumbotron').css({"background-color":"white"});
      $('span.info,.col-md-10, .col-md-3,.jumbotron').css("border","2px solid #E6BAAC");
      $('em>a,.col-md-10>a,.col-md-3>a,p>a,h3,h4').css({"color":"rgb(51, 122, 183)"})
      $('span,p,h3,h2,h1').css({'color':"rgb(51, 51, 51)"});
      $('.thumbnail').css({"background-color":'white'})
      $('nav').removeClass("navbar-inverse").addClass("navbar-default");
      $.ajax({
              url: "${request.route_url('theme')}?theme="+Cookies.get('theme'),
              type: "GET",
              dataType: "html"
          });
      return
    }
  });
});

% if request.registry.settings.get('auto_reload'):
//check if the auto_reload is in the settings
localStorage['load_id'] = $(".tweet_div")[0].id;
console.log(localStorage['load_id']);
if (localStorage['load_id'] != localStorage['old_id']){
  $("#"+localStorage['load_id']).offset().top = localStorage['load_id_position'];
  localStorage['old_id'] = localStorage['load_id'];
}

var time = new Date().getTime();
$(document.body).bind("mousemove keypress", function(e) {
  localStorage['load_id_position'] = $("#"+localStorage['load_id']).offset().top;
  time = new Date().getTime();
});

function refresh() {
if(new Date().getTime() - time >= 60000)
  window.location.reload(true);
else
  setTimeout(refresh, 60000);
}

setTimeout(refresh, 60000);
//endif mako
% endif
</script>
<!-- Google Analytics: change UA-XXXXX-X to be your site's ID. -->
<script>
(function(b,o,i,l,e,r){b.GoogleAnalyticsObject=l;b[l]||(b[l]=
  function(){(b[l].q=b[l].q||[]).push(arguments)});b[l].l=+new Date;
  e=o.createElement(i);r=o.getElementsByTagName(i)[0];
  e.src='//www.google-analytics.com/analytics.js';
  r.parentNode.insertBefore(e,r)}(window,document,'script','ga'));
  ga('create','UA-XXXXX-X','auto');ga('send','pageview');
  </script>
  </%block>
</body>
</html>
