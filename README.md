# go-tracer-perf
Deploy different versions of a go application to compare their performance thanks to datadog go expvar metrics.

# Usage

1. Create the different versions of the app you want to test and put them into the [bin](https://github.com/gabsn/go-tracer-perf/tree/master/bin) folder.
For example, if you're using dep, modify the constraints in the `Gopkg.toml`, `dep ensure` and then `go build` your app.

2. Rename your binaries by following the naming convention `APP-VERSION`. 
For example, `nicky-develop`, where `nicky` is the name of the app and `develop` the name of the branch.

3. If you have `n` versions to compare, provide `n` hosts in [the hosts list](https://github.com/gabsn/go-tracer-perf/blob/master/main.sh#L9).
The binaries will be deployed on them.
*Note:* you should only provide hosts that come from the same availibility zone for better results in the comparison. You can use the datadog hostmap to visualize what hosts are in which availibility zone for example.

4. Run the script with `./main.sh`.
