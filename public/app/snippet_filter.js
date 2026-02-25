window.addEventListener('load', _ => {
    document.getElementById("snippet-filter").addEventListener('keyup', e => {
        /** @type HTMLInputElement | null */
        const searchFilterEl = e.currentTarget;
        if (!searchFilterEl) return;

        /** @type HTMLDivElement | null */
        const snippetList = document.getElementById("snippet-list")
        if (!snippetList) return;

        const filter = searchFilterEl.value;

        for (const snippetSection of snippetList.children) {
            /** @type string */
            const slug = snippetSection.dataset.slug
            const title = snippetSection.dataset.title

            const tagSpans = snippetSection.querySelectorAll('.tag-span')
            const tags = Array.from(tagSpans).map(span => span.dataset.tag || '')

            const matches = !filter ||
                (slug && slug.includes(filter)) ||
                (title && title.includes(filter)) ||
                tags.some(tag => tag && tag.includes(filter))
            if (matches)
                snippetSection.classList.remove("hidden")
            else
                snippetSection.classList.add("hidden")
        }
    })
})
