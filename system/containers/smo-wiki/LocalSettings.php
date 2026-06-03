#$wgReadOnly = 'Backing up database, access will be restored shortly';

$wgFixDoubleRedirects = true;
$wgDebugLogGroups = [ 'rewrite' => '/tmp/rewrite.log' ];
$wgDebugLogFile = "/tmp/mediawiki-debug.log";

$wgSitename = "Super Mario Odyssey Wiki";
$wgMetaNamespace = "SMO_Wiki";

## The URL base path to the directory containing the wiki;

## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs
## (like /w/index.php/Page_title to /wiki/Page_title) please see:
## https://www.mediawiki.org/wiki/Manual:Short_URL
$wgArticlePath = "/$1";
#$wgUsePathInfo = true;
$wgMainPageIsDomainRoot = true;

$actions = array( 'edit', 'watch', 'unwatch', 'delete', 'revert', 'rollback',
  'protect', 'unprotect', 'markpatrolled', 'render', 'submit', 'history', 'purge', 'info' );

foreach ( $actions as $action ) {
  $wgActionPaths[$action] = "/$1/$action";
}

## The URL paths to the logo.  Make sure you change this from the default,
## or else you'll overwrite your logo when you upgrade!
$wgLogos = [
	'1x' => "/static/logo.svg",
	'icon' => "/static/logo.svg",
	'wordmark' => [
	  'src' => "/static/wordmark2.png",
		'width' => 263,
		'height' => 28,
	]
];

$wgFavicon = "/static/logo-144x144.png";

## UPO means: this is also a user preference option

$wgEnableEmail = true;
$wgEnableUserEmail = true; # UPO

$wgRateLimit['changeemail']['user'] = [ 10, 86400 ];
$wgAccountCreationThrottle = 6;

$wgEnotifUserTalk = false; # UPO
$wgEnotifWatchlist = false; # UPO
$wgEmailAuthentication = true;

## Shared memory settings
$wgMainCacheType = CACHE_ACCEL;
$wgMemCachedServers = [];

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads = true;
$wgGenerateThumbnailOnParse = true;

$wgFileExtensions[] = 'svg';
$wgFileExtensions[] = 'webm';
$wgAllowTitlesInSVG = true;
# moved to nixos config
#$wgSVGConverters = [ 'rsvg' => 'rsvg-convert -w $width -h $height -o $output $input' ];
$wgSVGConverter = 'rsvg';

$wgMaxAnimatedGifArea = 10e7;

# InstantCommons allows wiki to use images from https://commons.wikimedia.org
$wgUseInstantCommons = false;

# Periodically send a pingback to https://www.mediawiki.org/ with basic data
# about this MediaWiki instance. The Wikimedia Foundation shares this data
# with MediaWiki developers to help guide future development efforts.
$wgPingback = true;

# Site language code, should be one of the list in ./includes/languages/data/Names.php
$wgLanguageCode = "en";

# Time zone
$wgLocaltimezone = "UTC";

# Changing this will log out all existing sessions.
$wgAuthenticationTokenVersion = "1";

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "https://creativecommons.org/licenses/by-sa/4.0/";
$wgRightsText = "Creative Commons Attribution-ShareAlike";
$wgRightsIcon = "$wgResourceBasePath/resources/assets/licenses/cc-by-sa.png";

# Path to the GNU diff3 utility. Used for conflict resolution.

# User group permissions
$wgGroupPermissions['*'   ]['createpage'] = false;
$wgGroupPermissions['user']['createpage'] = true;
#$wgGroupPermissions['*'   ]['edit'      ] = false;
$wgCaptchaTriggers['edit'] = true;
$wgGroupPermissions['user']['skipcaptcha'] = true;
$wgGroupPermissions['*'   ]['createaccount'  ] = true;

$wgGroupPermissions['sysop']['deleterevision'] = true;
$wgGroupPermissions['sysop']['deletelogentry'] = true;

# ChangeAuthor
$wgGroupPermissions['sysop']['changeauthor'] = true;


# ConfirmEdit
wfLoadExtension('ConfirmEdit');
$wgCaptchaClass = "Turnstile";
$wgCaptchaClass = MediaWiki\Extension\ConfirmEdit\Turnstile\Turnstile::class;

# DiscordNotifications
$wgDiscordFromName = "SMO.wiki";
$wgDiscordNotificationWikiUrl = "https://smo.wiki/";
$wgDiscordNotificationWikiUrlEnding = "";
$wgDiscordSendMethod = "curl";
$wgDiscordShowNewUserFullName = false;
$wgDiscordNotificationWikiUrlEndingEditArticle = "/edit";
$wgDiscordNotificationWikiUrlEndingDeleteArticle = "/delete";
$wgDiscordNotificationWikiUrlEndingHistory = "/history";
$wgDiscordNotificationWikiUrlEndingDiff = "?diff=prev&oldid=";
$wgDiscordIncludeUserUrls = false;

$wgDiscordNotificationNewUser = false;
$wgDiscordNotificationBlockedUser = false;
$wgDiscordNotificationUserGroupsChanged = true;
$wgDiscordNotificationAddedArticle = true;
$wgDiscordNotificationRemovedArticle = true;
$wgDiscordNotificationMovedArticle = true;
$wgDiscordNotificationEditedArticle = true;
$wgDiscordNotificationFileUpload = true;
$wgDiscordNotificationProtectedArticle = true;
$wgDiscordNotificationFlow = true;
$wgDiscordNotificationAfterImportPage = true;
$wgDiscordDisableEmbedFooter = true;


# EmbedVideo
$wgEmbedVideoRequireConsent = false;
$wgEmbedVideoDefaultWidth = 600;


# Popups
$wgPopupsReferencePreviewsBetaFeature = false;


# StubUserWikiAuth
$wgAuthManagerAutoConfig['primaryauth'][StubUserWikiAuth\StubUserWikiPasswordAuthenticationProvider::class] = [
	'class' => StubUserWikiAuth\StubUserWikiPasswordAuthenticationProvider::class,
	'args' => [ [
		'apiUrl' => 'https://smo.wiki/mediawiki/api.php',
		'prefsUrl' => 'https://smo.wiki/Special:Preferences',
		'authoritative' => false,
		'promptPasswordChange' => true,
		'fetchUserOptions' => true
	] ],
	'sort' => 10,
];
$wgDebugLogGroups['StubUserWikiAuth'] = '/var/log/mediawiki/StubUserWikiAuth_' . date('Ymd') . '.log';


# TimedMediaHandler
$wgTranscodeBackgroundTimeLimit = 0;


# TitleKey
#$wgSearchType = Mediawiki\Extension\TitleKEy\SearchEngine::class;


#StopForumSpam
$wgSFSIPListLocation = "/var/lib/mediawiki/listed_ip_30_all.txt";

#function prettyDiffURLs( $title, &$url, $query ) {
#	if ( preg_match( '/^diff=(\w+)&oldid=(\w+)$/', $query, $matches ) ) {
#		$dbkey = wfUrlencode( $title->getPrefixedDBkey() );
#		$url = "/diff/$dbkey/$matches[1]/$matches[2]";
#	}
#	return true;
#}
#$wgHooks['GetLocalURL::Internal'][] = 'prettyDiffURLs';

#DarkMode
# this does fuck all
# $wgDarkModeTogglePosition = "footer";
$wgVectorNightMode['beta'] = false;
$wgVectorNightMode['logged_out'] = true;
$wgVectorNightMode['logged_in'] = true;
$wgDefaultUserOptions['vector-theme'] = 'os';

## uncomment this to debug mediawiki errors
$wgShowExceptionDetails = true;
#$wgShowDBErrorBacktrace = true;
#$wgShowSQLErrors = true;
#$wgDebugDumpSql = true;
