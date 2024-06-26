#!/bin/bash

case "${{ github.event.action }}" in
    "closed")
        if [ ${{ github.event.pull_request.merged }} == true ]; then
            GITHUB_USERS='["${{ github.event.pull_request.user.login }}"]'
        else
            GITHUB_USERS='[]'
        fi
        ;;
    *)
        GITHUB_USERS='${{ toJson(github.event.pull_request.requested_reviewers.*.login) }}'
esac

GITHUB_USER_IDS=$(echo "$GITHUB_USERS" | jq -r '.[]')
TO_PART=""
for GITHUB_ID in $GITHUB_USER_IDS
do
CHATWORK_ID=$(echo $USER_MAPPING | jq -r ".[\"$GITHUB_ID\"]")

if [ -n "$CHATWORK_ID" ]; then
    if [ "$CHATWORK_ID" == "toall" ]; then
    TO_PART+="[toall]"
    else
    TO_PART+="[To:${CHATWORK_ID}] $GITHUB_ID"
    fi
fi
done

MESSAGE=$(printf "[info][title]プルリクエスト通知: ${{ github.event.pull_request.title }}[/title]\n")

# プルリクエスト
if [ -n "${{ github.event.pull_request }}" ]; then
    MESSAGE+="プルリクエスト"
    # レビュー
    if [ -n "${{ github.event.review }}" ]; then
        MESSAGE+="に対するレビュー"
        case "${{ github.event.action }}" in
        "submitted")
            MESSAGE+="が作成されました"
            ;;
        *)
            MESSAGE+="が更新されました"
            MESSAGE+="DEBUG[pull_request.review: ${{ github.event.action }}]"
        esac
    # プルリクエスト
    else
        case "${{ github.event.action }}" in
        "opened"|"reopened")
            MESSAGE+="が作成されました"
            ;;
        "edited"|"review_requested"|"assigned")
            MESSAGE+="が更新されました"
            ;;
        "synchronize")
            MESSAGE+="に新しいコミットがプッシュされました。"
            ;;
        "closed")
            if [ "${{ github.event.pull_request.merged }}" == "true" ]; then
            MESSAGE+="がマージされました"
            else
            MESSAGE+="が閉じられました"
            fi
            ;;
        *)
            MESSAGE+="DEBUG[pull_request: ${{ github.event.action }}]"
        esac
    fi
# プルリクエストコメント
elif [ -n "${{ github.event.comment }}" ] && [ -n "${{ github.event.issue.pull_request }}" ]; then
    MESSAGE+="[ISSUE]プルリクエストに対するコメント"
    case "${{ github.event.action }}" in
    "created")
        MESSAGE+="が作成されました"
        ;;
    "edited")
        MESSAGE+="が更新されました"
        ;;
    *)
        MESSAGE+="DEBUG[issue_comment: ${{ github.event.action }}]"
    esac
else
    MESSAGE+="DEBUG[github.event: ${{ github.event.action }}]"
    MESSAGE+="[/info][info][title]DEBUG: github.event[/title]"
    MESSAGE+="${{ toJson(github.event) }}"
    MESSAGE+="[/info][info]"
fi

MESSAGE+=$(printf "\n\n${{ github.event.pull_request.html_url }}")
MESSAGE+=$(printf "\nFROM: ${{ github.event.pull_request.user.login }}")
MESSAGE+=$(printf "[/info]")


curl --request POST \
    --url https://api.chatwork.com/v2/rooms/${CHATWORK_ROOM_ID}/messages \
    --header "accept: application/json" \
    --header "content-type: application/x-www-form-urlencoded" \
    --header "x-chatworktoken: ${CHATWORK_TOKEN}" \
    --data-urlencode "body=${TO_PART}${MESSAGE}" \
    --data self_unread=1
