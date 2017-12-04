{{- $daemon_code := env "CDAEMON_CODE" | toLower -}}
{{- $daemon_id := env "CDAEMON_ID" | toLower -}}

{{ range ls (print "cdaemons/" $daemon_code "/default") }}
{{- $key_path := print "cdaemons/" $daemon_code "/" $daemon_id "/" .Key -}}
{{- if not (keyExists $key_path) -}}
{{ .Key }}={{ .Value }}
{{- $parent_key := .Key }}
{{ range ls (print "cdaemons/" $daemon_code "/default/" $parent_key "/") -}}
{{ $parent_key }}={{ .Value }}
{{ end -}}
{{ end -}}
{{ end }}

{{ range ls (print "cdaemons/" $daemon_code "/" $daemon_id) -}}
{{ .Key }}={{ .Value }}
{{- $parent_key := .Key }}
{{ range ls (print "cdaemons/" $daemon_code "/" $daemon_id "/" $parent_key "/") -}}
{{ $parent_key }}={{ .Value }}
{{ end -}}
{{ end -}}
