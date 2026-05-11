#$wgReadOnly = 'Backing up database, access will be restored shortly';

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
#$wgMainPageIsDomainRoot = false;

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
$wgGroupPermissions['*'   ]['edit'      ] = false;
$wgGroupPermissions['*'   ]['createaccount'  ] = false;

$wgGroupPermissions['sysop']['deleterevision'] = true;
$wgGroupPermissions['sysop']['deletelogentry'] = true;

# ChangeAuthor
$wgGroupPermissions['sysop']['changeauthor'] = true;


# ConfirmEdit
$wgCaptchaClass = "Turnstile";
# $wgCaptchaQuestions = [
# 	'Which kingdom is Bonneton in?' => [ 'Cap', 'Cap Kingdom' ],
# 	'Which kingdom is Fossil Falls in?' => [ 'Cascade', 'Cascade Kingdom' ],
# 	'Which kingdom is Tostarena in?' => [ 'Sand', 'Sand Kingdom' ],
# 	'Which kingdom is Lake Lamode in?' => [ 'Lake', 'Lake Kingdom' ],
# 	'Which kingdom is Steam Gardens in?' => [ 'Wooded', 'Wooded Kingdom' ],
# 	'Which kingdom is Nimbus Arena in?' => [ 'Cloud', 'Cloud Kingdom' ],
# 	'Which kingdom is Forgotten Isle in?' => [ 'Lost', 'Lost Kingdom' ],
# 	'Which kingdom is New Donk City in?' => [ 'Metro', 'Metro Kingdom' ],
# 	'Which kingdom is Shiveria in?' => [ 'Snow', 'Snow Kingdom' ],
# 	'Which kingdom is Bubblaine in?' => [ 'Seaside', 'Seaside Kingdom' ],
# 	'Which kingdom is Mount Volbono in?' => [ 'Luncheon', 'Luncheon Kingdom' ],
# 	'Which kingdom is Crumbleden in?' => [ 'Ruined', 'Ruined Kingdom' ],
# 	'Which kingdom is Bowser\'s Castle in?' => [ 'Bowser', 'Bowsers', 'Bowser\'s', 'Bowser Kingdom', 'Bowsers Kingdom', 'Bowser\'s Kingdom' ],
# 	'Which kingdom is Honeylune Ridge in?' => [ 'Moon', 'Moon Kingdom' ],
# 	'Which kingdom is Peach\'s Castle in?' => [ 'Mushroom', 'Mushroom Kingdom' ],
# 	'Which kingdom is Rabbit Ridge in?' => [ 'Dark', 'Dark Side' ],
# 	'Which kingdom is Culmina Crater in?' => [ 'Darker', 'Darker Side' ],
# 
# 	'Which kingdom do Bonneters live in?' => [ 'Cap', 'Cap Kingdom' ],
# 	'Which kingdom do Tostarenans live in?' => [ 'Sand', 'Sand Kingdom' ],
# 	'Which kingdom do Lochladies live in?' => [ 'Lake', 'Lake Kingdom' ],
# 	'Which kingdom do Steam Gardeners live in?' => [ 'Wooded', 'Wooded Kingdom' ],
# 	'Which kingdom do New Donkers live in?' => [ 'Metro', 'Metro Kingdom' ],
# 	'Which kingdom do Shiverians live in?' => [ 'Snow', 'Snow Kingdom' ],
# 	'Which kingdom do Bubblainians live in?' => [ 'Seaside', 'Seaside Kingdom' ],
# 	'Which kingdom do Volbonans live in?' => [ 'Moon', 'Moon Kingdom' ],
# 	'Which kingdom do Toads live in?' => [ 'Mushroom', 'Mushroom Kingdom' ],
# 
# 	'How many regional coins are there in Cap Kingdom?' => [ 50, 'fifty' ],
# 	'How many regional coins are there in Cascade Kingdom?' => [ 50, 'fifty' ],
# 	'How many regional coins are there in Sand Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 	'How many regional coins are there in Lake Kingdom?' => [ 50, 'fifty' ],
# 	'How many regional coins are there in Wooded Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 	'How many regional coins are there in Lost Kingdom?' => [ 50, 'fifty' ],
# 	'How many regional coins are there in Metro Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 	'How many regional coins are there in Snow Kingdom?' => [ 50, 'fifty' ],
# 	'How many regional coins are there in Seaside Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 	'How many regional coins are there in Luncheon Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 	'How many regional coins are there in Bowser\'s Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 	'How many regional coins are there in Moon Kingdom?' => [ 50, 'fifty' ],
# 	'How many regional coins are there in Mushroom Kingdom?' => [ 100, 'hundred', 'a hundred', 'one hundred' ],
# 
# 	'In which kingdom can you buy the Top Hat and Tuxedo?' => [ 'Cap', 'Cap Kingdom' ],
# 	'In which kingdom can you buy the Caveman outfit?' => [ 'Cascade', 'Cascade Kingdom' ],
# 	'In which kingdom can you buy the Sombrero and Poncho?' => [ 'Sand', 'Sand Kingdom' ],
# 	'In which kingdom can you buy the Cowboy outfit?' => [ 'Sand', 'Sand Kingdom' ],
# 	'In which kingdom can you buy the Swim Goggles and Swimwear?' => [ 'Lake', 'Lake Kingdom' ],
# 	'In which kingdom can you buy the Explorer outfit?' => [ 'Wooded', 'Wooded Kingdom' ],
# 	'In which kingdom can you buy the Scientist outfit?' => [ 'Wooded', 'Wooded Kingdom' ],
# 	'In which kingdom can you buy the Aviator outfit?' => [ 'Lost', 'Lost Kingdom' ],
# 	'In which kingdom can you buy the Builder outfit?' => [ 'Metro', 'Metro Kingdom' ],
# 	'In which kingdom can you buy the Golf outfit?' => [ 'Metro', 'Metro Kingdom' ],
# 	'In which kingdom can you buy the Snow Hood and Suit?' => [ 'Snow', 'Snow Kingdom' ],
# 	'In which kingdom can you buy the Resort outfit?' => [ 'Seaside', 'Seaside Kingdom' ],
# 	'In which kingdom can you buy the Chef outfit?' => [ 'Luncheon', 'Luncheon Kingdom' ],
# 	'In which kingdom can you buy the Painter outfit?' => [ 'Luncheon', 'Luncheon Kingdom' ],
# 	'In which kingdom can you buy the Samurai outfit?' => [ 'Bowser', 'Bowsers', 'Bowser\'s', 'Bowser Kingdom', 'Bowsers Kingdom', 'Bowser\'s Kingdom' ],
# 	'In which kingdom can you buy the Happi outfit?' => [ 'Bowser', 'Bowsers', 'Bowser\'s', 'Bowser Kingdom', 'Bowsers Kingdom', 'Bowser\'s Kingdom' ],
# 	'In which kingdom can you buy the Astronaut outfit?' => [ 'Moon', 'Moon Kingdom' ],
# 	'In which kingdom can you buy the 64 outfit?' => [ 'Mushroom', 'Mushroom Kingdom' ],
# 
# 	'How many Power Moons is one Multi Moon worth?' => [ 3, 'three' ],
# 	'How many Power Moons are required to get to Dark Side?' => [ 250, 'two hundred fifty', 'two hundred and fifty' ],
# 	'How many Power Moons are required to get to Darker Side?' => [ 500, 'five hundred' ],
# 
# 	'What does Bowser steal from Sand Kingdom?' => [ 'ring', 'Binding Band' ],
# 	'What does Bowser steal from Lake Kingdom?' => [ 'dress', 'Lochlady Dress' ],
# 	'What does Bowser steal from Wooded Kingdom?' => [ 'flowers', 'bouquet', 'bouquet of flowers', 'Soirée Bouquet', 'Soiree Bouquet' ],
# 	'What does Bowser steal from Snow Kingdom?' => [ 'cake', 'Frost-Frosted Cake', 'Frost Frosted Cake' ],
# 	'What does Bowser steal from Seaside Kingdom?' => [ 'water', 'Sparkle Water' ],
# 	'What does Bowser steal from Luncheon Kingdom?' => [ 'stew', 'Stupendous Stew' ],
# 
# 	'In which kingdom does Topper first appear?' => [ 'Cap', 'Cap Kingdom' ],
# 	'In which kingdom does Madame Broode first appear?' => [ 'Cascade', 'Cascade Kingdom' ],
# 	'In which kingdom does Hariet first appear?' => [ 'Sand', 'Sand Kingdom' ],
# 	'In which kingdom does Knucklotec first appear?' => [ 'Sand', 'Sand Kingdom' ],
# 	'In which kingdom does Rango first appear?' => [ 'Lake', 'Lake Kingdom' ],
# 	'In which kingdom does Spewart first appear?' => [ 'Wooded', 'Wooded Kingdom' ],
# 	'In which kingdom does Torkdrift first appear?' => [ 'Wooded', 'Wooded Kingdom' ],
# 	'In which kingdom does Mechawiggler first appear?' => [ 'Metro', 'Metro Kingdom' ],
# 	'In which kingdom does Mollusque-Lanceur first appear?' => [ 'Seaside', 'Seaside Kingdom' ],
# 	'In which kingdom does Cookatiel first appear?' => [ 'Luncheon', 'Luncheon Kingdom' ],
# 	'In which kingdom does the Lord of Lightning first appear?' => [ 'Ruined', 'Ruined Kingdom' ],
# 	'In which kingdom does RoboBrood first appear?' => [ 'Bowser', 'Bowsers', 'Bowser\'s', 'Bowser Kingdom', 'Bowsers Kingdom', 'Bowser\'s Kingdom' ],
# 
# 	'How many coins are required to ride on a Jaxi?' => [ 30, 'thirty' ],
# 	'How many Jaxi statues are on top of the Inverted Pyramid?' => [ 5, 'five' ],
# 	'How many fountains are sealed by Bowser in Seaside Kingdom?' => [ 4, 'four' ],
# ];


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

## uncomment this to debug mediawiki errors
$wgShowExceptionDetails = true;
#$wgShowDBErrorBacktrace = true;
#$wgShowSQLErrors = true;
#$wgDebugDumpSql = true;
