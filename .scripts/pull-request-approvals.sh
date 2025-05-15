#!/usr/bin/env bash
gh search prs --state open --assignee @me --json number,title,repository --template '{{range $i, $el := .}}{{if $i}},{{end}}{{.repository.name}} {{.title}}|{{.repository.name}} {{.number}}{{end}}' | gum choose --no-limit --label-delimiter="|" --input-delimiter="," | xargs -I {} -L 1 sh -c "gh pr review --approve --repo NBCUDTC/{}"
