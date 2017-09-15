# go-perf
Deploy different versions of a go application in a real environment and visualize their performance in datadog thanks to expvar metrics.

## Usage

1. Create the different versions of the app you want to test and put them into the [bin](https://github.com/gabsn/go-tracer-perf/tree/master/bin) folder.
For example, if you're using dep, modify the constraints in the `Gopkg.toml`, `dep ensure` and then `go build` your app.

2. Rename your binaries by following the naming convention `APP-VERSION`. 
For example, `nicky-develop`, where `nicky` is the name of the app and `develop` the name of the branch.

3. If you have `n` versions to compare, provide `n` hosts in [the hosts list](https://github.com/gabsn/go-tracer-perf/blob/master/hosts).
The binaries will be deployed on them.

4. Run the script with `./main.sh`.

5. Visualize your metrics in the datadog app.

![dashboard](https://github.com/gabsn/go-perf/blob/img/dashboard.png)

## Tips

You should only provide hosts that come from the same availibility zone for better results in the comparison. You can use the datadog hostmap to visualize the hosts running your app per availibility zone.
Then inspect the page and go to `network` tab, click on `overview?` and save `rows` as a global variable. 
Then open the chrome js console and type:
```js
hosts = temp1.filter(row => row.tags_by_source["Amazon Web Services"][0].includes("us-east-1a")).map(row => row.display_name)
hosts.forEach(h => console.log(h))
```
This way you'll be able to provide only the hosts for a given availibility zone.
