# Hass.io Add-ons: Metricbeat

This add-on allows you to log metricbeat metrics for Home Assistant to your elasticsearch cluster.

## About

Metricbeat is a lightweight shipper for metrics. It is designed to forward these metrics to ElasticSearch.

## WARNING

This plugin requires access to several internal features of HassIO such as the host network, docker and other system resources. Do not install this plugin unless you are comfortable providing it that level of access.

## Configuration

```json
{
    "elasticsearch_host": "elasticsearch",
    "elasticsearch_port": 9200,
    "elasticsearch_user": "",
    "elasticsearch_password": ""
}
```

### Option: `elasticsearch_host`

The `elasticsearch_host` option sets the name or IP address of the elasticsearch host data will be logged to. This will default to a host named `elasticsearch`.

### Option: `elasticsearch_port`
 
The port ElasticSearch is listening to on `elasticsearch_host`.

### Option: `elasticsearch_user` and `elasticsearch_password`

These two options specify the user and password to be used if your ElasticSearch server requires authentication.

## Known issues and limitations


## Support

Questions? 
