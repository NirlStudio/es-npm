const fs (import "$fs");
const path (import "$path");
const shell (import "$shelljs");
const profile (import "./profile");

const app-name (path basename (env "home");

(const repo-of (= (template)
  'https://github.com/NirlStudio/sugly-npm-template-$(template ?* "default")'
).

(const clone (=> (repo)
  log info "Downloading template ...";
  shell exec 'git clone $repo .';
  shell rm "-rf", ".git/";
  (fs existsSync "package.json") and (fs existsSync "sugly/");
).

(const update-info (=> (pkg)
  log info "Updating package.json ...";
  const info (profile read);
  (if (info email:: is-empty)
    pkg "author", (info name);
  else
    (pkg "author", (@
      name: (info name),
      email: (info email)
    ).
  ).
  pkg "license", (info license);
  pkg "name", app-name;
  pkg "description", app-name;
  (pkg "bin", (@:@
    (app-name): 'bin/$app-name'
  ).
  pkg "repository", "";
  pkg "keywords", (@ "sugly");
).

(const compact (=> (pkg)
  log info "Compacting package ...";
  object reset (pkg scripts), "test";
  object reset pkg, "standard";
  object reset pkg, "devDependencies";

  shell rm "-rf", "test/";
  shell rm "-rf", ".vscode/";
).

(const finalize-with (=> (options)
  log info "Renaming executable file ...";
  shell mv "bin/hello", 'bin/$app-name';
  shell mv "bin/hello.cmd", 'bin/$(app-name).cmd';

  # without this, a sugly dependency will not be linked.
  log info "Creating sugly/modules ...";
  shell mkdir "sugly/modules"

  log info "Generating README.md ...";
  fs writeFileSync "README.md", "* $app-name\n\n**UPDATE ME**";

  log info "Installing dependencies ...";
  shell exec "npm install";
  (if (fs readdirSync "node_modules":: is-empty)
    (log warn 'Failed to install dependencies. ($code)
               Please run "npm install" to fix the problem.'
    ).
).

(const customize-with (=> (options)
  const pkg (json parse (fs readFileSync "package.json", "utf-8");
  (if (pkg is-not-an object)
    log err "Invalid package.json.";
    return false;
  ).

  update-info pkg;
  (if (options contains "--dev")
    pkg dependencies:: "sugly", "NirlStudio/sugly-lang#development";
  ).
  (if (options contains "--compact")
    compact pkg;
  ).
  fs writeFileSync "package.json", (json of pkg);

  finalize-with options;
  return true;
).

(export init (=> (template, options)
  (if (fs readdirSync (env "home"):: not-empty)
    log warn "This is not a clean directory:";
    (shell ls "-A":: first 6, (= (item, index)
      print "  ", (index is (6 th):: ? "...", item);
    ).
    return false;
  ).

  var repo (repo-of template);
  (if (clone repo:: fails)
    log err "Failed to download project template from", repo;
    return false;
  ).

  (if (customize-with options:: fails)
    log err "Failed to setup project.", "gray";
    return false;
  ).

  printf 'Project $app-name has been initialized. Enjoy the sugliness.\n', "green";
  return true;
).
