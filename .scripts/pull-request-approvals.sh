#!/usr/bin/env bash
# Set your GitHub org here
GH_ORG="${GH_ORG:-<YOUR_ORG>}"
gh search prs --state open --assignee @me --json number,title,repository --template '{{range $i, $el := .}}{{if $i}},{{end}}{{.repository.name}} {{.title}}|{{.repository.name}} {{.number}}{{end}}' | gum choose --no-limit --label-delimiter="|" --input-delimiter="," | xargs -I {} -L 1 sh -c "gh pr review --approve --repo $GH_ORG/{}"
