octotunnel:
  image: joshuacox/mktunnel:${TAG}
  environment:
    KEY_ECDSA:      ${KEY_ECDSA}
    LOCAL_PORT:     ${LOCAL_PORT}
    REMOTE_PORT:    ${REMOTE_PORT}
    REMOTE_USER:    ${REMOTE_USER}
    REMOTE_HOST:    ${REMOTE_HOST}
    MONITOR_PORT:   ${MONITOR_PORT}
    FORWARDED_PORT: ${FORWARDED_PORT}
  ports:
  - "${LOCAL_PORT}:${LOCAL_PORT}"
  labels:
    io.rancher.container.hostname_override: container_name
  {{- if ne .Values.host_label ""}}
    io.rancher.scheduler.affinity:host_label: ${host_label}
  {{- end}}
{{- if ne .Values.extlink ""}}
  external_links:
    - ${external_link}:extlink
{{- end}}
