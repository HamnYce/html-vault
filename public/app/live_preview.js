window.addEventListener('load', _ => {
    /** @type HTMLTextAreaElement */
    const snippetHTMLContent = document.getElementById('snippet-html-content')
    /** @type HTMLIFrameElement | null */
    const livePreview = document.getElementById('live-preview')
    if (!snippetHTMLContent || !livePreview) return

    function updatePreview() {
        livePreview.setAttribute('srcdoc', snippetHTMLContent.value)
    }

    updatePreview()
    snippetHTMLContent.addEventListener('input', updatePreview)
})