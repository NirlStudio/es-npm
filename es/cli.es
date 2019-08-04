const fs (espress (import "$fs");
const path (import "$path");
const shell (import "$shelljs");
const profile (import "./profile");

const app-name (path basename (env "home");

(const repo-of (= (template)
  'https://github.com/NirlStudio/es-npm-template-$(template ?* "default")'
).

(const clone (=> (repo)
  log info "Downloading template ...";
  shell exec 'git clone $repo .';
  shell rm "-rf", ".git/";
  (fs exists-sync "package.json") and (fs exists-sync "es/");
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
  (if  (pkg "bin":: not-empty)
    (pkg "bin", (@:@
      (app-name): 'bin/$app-name'
  ).
  pkg "repository", "";
  pkg "keywords", (@ "eslang", "espresso", "espressolang", "espresso-lang");
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
  (if (fs exists-sync "bin/hello")
    log info "Renaming executable file ...";
    shell mv "bin/hello", 'bin/$app-name';
    shell mv "bin/hello.bat", 'bin/$(app-name).bat';
  ).

  # without this, an Espresso dependency will not be linked.
  (if (fs exists-sync "es/modules":: is-not true)
    log info "Creating es/modules ...";
    shell mkdir "es/modules";
  ).

  log info "Generating README.md ...";
  fs write-file-sync "README.md", '# $app-name\n\n**UPDATE ME**';

  log info "Installing dependencies ...";
  shell exec "npm install";
  (if (fs readdir-sync "node_modules":: is-empty)
    (log warn 'Failed to install dependencies. ($code)
               Please run "npm install" to fix the problem.'
    ).
).

(const customize-with (=> (options)
  const pkg (json parse (fs read-file-sync "package.json", "utf-8");
  (if (pkg is-not-an object)
    log err "Invalid package.json.";
    return false;
  ).

  update-info pkg;
  (if (options contains "--dev")
    pkg dependencies:: "es", "github:NirlStudio/eslang#development";
  ).
  (if (options contains "--compact")
    compact pkg;
  ).
  fs write-file-sync "package.json", (json of pkg);

  finalize-with options;
  return true;
).

(export init (=> (template, options)
  (if (fs readdir-sync (env "home"):: not-empty)
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

  printf 'Project $app-name has been initialized. Enjoy the Espresso.\n', "green";
  return true;
).
