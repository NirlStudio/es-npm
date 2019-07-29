#!/usr/bin/env es

const cli (import "./cli");
const profile (import "./profile");

(const valid-templates (@
  "default", "app", "module", "api", "web"
).

(const valid-options (@
  "--compact", "-c", "--dev", "-d"
).

(const exit-with-help (= ()
  (print "
    Usage:\
    \tes-npm init [default|app|module|web|api] [-c|--compact] [-d|--dev]\
    \
    Templates:\
    \tdefault \tA project which may serve in both app and module modes.\
    \tapp     \tA project which only serves as an app.\
    \tmodule  \tA project which only serves as a module.\
    \tapi     \tAn app project which serves as a RESTful service.\
    \tweb     \tA web site project which serves as a web app.\
    \
    Options:\
    \t-c, --compact \tremove test code, dependency on mocha and default vscode settings.\
    \t-d, --dev \tuse development (non-published & unstable) branch of eslang.\
    "
  ).
  exit 1;
).

# separate command and options.
const commands (@);
const options (@);
(arguments for-each (=> word
  word starts-with "-":: ? options, commands:: push word;
).

# split command and template types.
var (command, template) commands;
(if (command is-not "init")
  log warn (command is-empty:: ? "Missing command.", 'Unknown command: $command');
  exit-with-help;
).

# validate template name.
if (template is-empty) (let template "default");
(if (valid-templates contains template:: is false)
  log warn 'Invalid template: $template';
  exit-with-help;
).

# prepare options
options replace "-c", "--compact";
options replace "-d", "--dev";
(const invalid-option (options first (=> opt
  valid-options contains opt:: is false;
).
(if (invalid-option not-empty)
  log warn 'Invalid option: $invalid-option';
  exit-with-help;
).

# finally, ready to go.
cli init template, options;
