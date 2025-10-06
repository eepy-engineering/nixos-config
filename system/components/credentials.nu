def main [
  tokenPath: path,
  configPath: path,
] {
  $env.OP_SERVICE_ACCOUNT_TOKEN = open -r $tokenPath
  let config = open $configPath;

  let opconfig = mktemp -d;
  $env.XDG_CONFIG_HOME = $opconfig;

  $config.secrets | each {|secret|
    print $"op read ($secret.reference)"
    let secretPath = ([$config.outputDir $secret.path] | path join);
    mkdir ($secretPath | path dirname)
    op read $secret.reference | save -f $secretPath
  };

  chown -R root:onepassword-secrets $config.outputDir
}
