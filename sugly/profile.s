const fs (import "$fs");
const path (import "$path");

const user-home (env "user-home");
const sugly-home (path resolve user-home, ".sugly");
const profile-path (path resolve sugly-home, "npm.s");

(const default-profile (=> () (@
  name: (path basename user-home),
  email: "",
  license: "MIT"
).

(export read (=> ()
  (if (fs existsSync user-home:: is false)
    return (default-profile );
  ).
  (if (fs existsSync sugly-home:: is false)
    fs mkdir sugly-home;
  ).
  (if (fs existsSync profile-path:: is false)
    fs writeFileSync profile-path, (default-profile :: to-code:: to-string);
    print "You can update default options by editing", profile-path;
  ).
  load profile-path;
).
