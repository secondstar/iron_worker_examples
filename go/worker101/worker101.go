package main

import (
        "fmt";
        "net/http";
        "net/url";
        "io";
        "io/ioutil";
        "flag";
        "os";
        "encoding/json";
        )

var d = flag.String("d", "", "Some param")
var e = flag.String("e", "", "Some param")
var task_id = flag.String("id", "", "Task id")
var payload = flag.String("payload", "", "payload")
var query = "iron.io"
const queryURI = "http://search.twitter.com/search.%s?q=%s&rpp=%d"
const outputfmt = "%s\n"


// JSON Data Structure

type Payload struct {
        Query string;
}

type JTweets struct {
        Results []Result;
        Max_id float32;
        Since_id int;
        Refresh_url string;
        Next_page string;
        Page int;
        Completed_in float32;
        Query string;

}

type Result struct {
        Profile_image_url string;
        Created_at string;
        From_user string;
        Text string;
        Id float32;
        From_user_id int;
        Iso_language_code string;
        Source string;
}


func ts(s string, n int)(twits []string) {
                r,err := http.Get(fmt.Sprintf(queryURI, "json", url.QueryEscape(s), n));
                if err == nil  {
                        fmt.Fprintf(os.Stderr, "\nSearching for '%s' (%d results in %s)\n",s, n, "json");
                        if r.StatusCode == http.StatusOK {
                                        twits = readjson(r.Body);
                        } else {
                                fmt.Fprintf(os.Stderr,
                                "Twitter is unable to search for %s as %s (%s)\n", s, "json",r.Status);
                        }
                        r.Body.Close();
                } else {
                        fmt.Fprintf(os.Stderr, "%v\n", err);
                }
                return;
}


func readjson(r io.ReadCloser)(twits []string) {
var twitter JTweets;
        var b []byte;
        b, err := ioutil.ReadAll(r);
        fmt.Printf(string(b));
        if err == nil {
               error:= json.Unmarshal(b, &twitter);
                if error == nil {
                        for i := 0; i < len(twitter.Results); i++ {
                                fmt.Printf(outputfmt,
                                        /*twitter.Results[i].From_user,*/ twitter.Results[i].Text);
                                        twits = append(twits, twitter.Results[i].Text);
                        }
                } else {
                        fmt.Fprintf(os.Stderr, "Unable to parse the JSON feed %v\n",error);
                }
        } else {
                fmt.Fprintf(os.Stderr, "%v\n", err);
        }
        return;
}



func main() {
        flag.Parse();
         file, e := ioutil.ReadFile(*payload)
                if e != nil {
                        fmt.Printf("File error: %v\n", e)
                        os.Exit(1)
                }
                fmt.Printf("Payload:%s\n", string(file))
                var p Payload;
                error:= json.Unmarshal(file, &p);
                if error == nil {
                    query = p.Query;
                }
        twits := ts(query, 20);

        if len(twits) > 0 {
            fmt.Printf("Writing to file:%s",twits[0])

            err:= ioutil.WriteFile("sample_file.txt", []byte(twits[0]),0644);
                if err != nil {
                    fmt.Printf("Error Writing to file:%s",err)
                }
        }
}