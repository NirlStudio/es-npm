#!/usr/bin/env sugly

const cli (import "./cli");
const profile (import "./profile");

(const valid-templates (@
  "default", "app", "module", "web", "api"
).

(const valid-options (@
  "--compact", "-c", "--dev", "-d"
).

(const exit-with-help (= ()
  (print "
    Usage:\
    \tsugly-npm init [default|app|module|web|api] [-c|--compact] [-d|--dev]\
    \
    Templates:\
    \tdefault \tA project which may serve in both app and module modes.\
    \tapp     \tA project which only serves as an app.\
    \tmodule  \tA project which only serves as a module.\
    \tweb     \tA web site project which serves as a sugly-based web app.\
    \tapi     \tAn app project which serves as a RESTful service.\
    \
    Options:\
    \t-c, --compact \tremove test code, dependency on mocha and default vscode settings.\
    \t-d, --dev \tuse development (non-published & unstable) branch of sugly-lang.\
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