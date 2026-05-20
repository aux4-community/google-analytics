# google analytics metadata

```timeout
15000
```

## with a valid property ID

### should return available dimensions and metrics

```execute
aux4 google analytics metadata ${GA4_PROPERTY_ID}
```

```expect:partial
"dimensions"
```

```expect:partial
"metrics"
```
