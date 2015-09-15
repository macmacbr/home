#!/usr/bin/awk -f
/function su_staff/ {
    print "found su_staff"
    fetchuser = true;
}
/function su_ads_team/ {
    print "found su_ads_team"
    exit 0;
}
fetchuser == true && /[0-9] +=> 1,/ {
    users[userslen++] = $1
}
END {
    print "USERS:";
    for ( i = 0; i < userslen; i++ )
           print users[i];
}
