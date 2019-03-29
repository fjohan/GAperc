

#: <<'#END_COMMENT'
awk '
NR > 2 && NR < 19 {
    match($0, /"sentw_([^"]*)":"([^"]*)"/, sent)
    sarr[sent[1]] = sent[2]
}
NR > 18 {
    if (NR % 17 == 2) {
        match($0, /"listeningCond":"([^"]*)"/, cond)
        #print arr[1]
    } else {
        match($0, /"([^"]*)":"([^"]*)"/, arr)
        #print arr[1],cond[1],arr[2]
        #print $1,arr[2] > arr[1]"_"cond[1]
        print $1"_"cond[1],arr[2] > arr[1]
    }
}
END {
    #printf "0" > "words"
    #for (i = 3; i < 19; i++)
    #    printf "%s",sarr[i] >> "words"
    #print "" >> "words"
    print "0 0" > "words"
    for (i = 3; i < 19; i++) {
        split(sarr[i],w)
        for (j = 1; j <= length(w); j++)
            print "sent_"i" "w[j] >> "words"
    }
    #print "" >> "words"
}
' GAperc.txt 
#END_COMMENT

#less words

#: <<'#END_COMMENT'
join sentg_3 sentg_4 > /tmp/j1
for a in $( seq 5 18 )
do
    join /tmp/j1 "sentg_"$a > /tmp/j2
    mv -f /tmp/j2 /tmp/j1
done
#mv -f /tmp/j1 sentg_all_speakers
#END_COMMENT

#: <<'#END_COMMENT'
cat /tmp/j1 | awk '
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str" "a[i,j];
        }
        print str
    }
}' > sentg_all
#END_COMMENT

paste -d " " words sentg_all | awk '
NR == 1 {
    for (i = 3; i <= NF; i++) {
        split($i,p,"_")
        cond[i] = p[2]
        id[i] = p[1]
    }
    printf "0 0"
    for (i = 3; i <= NF; i++) {
        printf " %s",cond[i]
    }
    print ""
    printf "0 0"
    for (i = 3; i <= NF; i++) {
        printf " %s",id[i]
    }
    print ""
}
NR > 1 { print $0 }
' > sentg_all.ssv

#head -20 GAperc.txt

#awk 'NR > 18 && (NR % 17) == 2 {print NR % 17,$0}' GAperc.txt | grep swedish | wc -l
