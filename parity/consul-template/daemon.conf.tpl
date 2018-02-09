{{- $daemon_code := env "CDAEMON_CODE" | toLower -}}
{{- $daemon_id := env "CDAEMON_ID" | toLower -}}

{{ range $section, $pairs := tree (print "cdaemons/" $daemon_code "/default") | byKey }}
{{/* remember that we have visited this section */}}
{{- scratch.Set $section "remember" }}
[{{ $section }}]
{{/* iterate over default keys in given section and use key only if specific key is not present */}}
{{- range $pair := $pairs -}}
{{- $key_path := print "cdaemons/" $daemon_code "/" $daemon_id "/" $section "/" .Key -}}
{{- if not (keyExists $key_path) -}}
{{ .Key }} = {{ .Value }}
{{ end }}{{ end }}
{{/* iterate over ALL specific keys and use them (we may have skipped some on previous step) */}}
{{- range ls (print "cdaemons/" $daemon_code "/" $daemon_id "/" $section) -}}
{{ .Key }} = {{ .Value }}
{{ end }}{{ end }}

{{ range $section, $pairs := tree (print "cdaemons/" $daemon_code "/" $daemon_id) | byKey }}
{{- if not (scratch.Get $section) -}}
{{/* use only sections we don't know */}}
[{{ $section }}]
{{ range $pair := $pairs -}}
{{ .Key }} = {{ .Value }}
{{ end }}{{ end }}{{ end }}
