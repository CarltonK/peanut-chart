# _helpers.tpl scope 
   name: {{ include "peanut.fullname" . }}
   labels: {{- include "peanut.labels" . | nindent 4 }}
   matchLabels:{{- include "peanut.selectorLabels" . | nindent 6 }}
   serviceAccountName: {{ include "peanut.serviceAccountName" . }}


# values.yaml scope
 replicas: {{ .Values.replicaCount }}
 image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
 imagePullPolicy: {{ .Values.image.pullPolicy }}
 serviceAccountName: {{ .Values.serviceAccount.name }}


# predefined scope
 containers:
   - name: {{ .Chart.Name }}

{{- define "peanut.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "peanut.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}


{{- define "peanut.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "peanut.labels" -}}
helm.sh/chart: {{ include "peanut.chart" . }}
{{ include "peanut.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "peanut.selectorLabels" -}}
app.kubernetes.io/name: {{ include "peanut.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}