// Sticky Applet JavaScript
// Makes interactive applets float/stick as users scroll
// Also injects custom CSS since Runestone doesn't serve external CSS files

// === CSS INJECTION ===
// Inject custom styles directly into the page since external/custom-styles.css
// is not served by Runestone Academy's hosting.
(function() {
    var style = document.createElement('style');
    style.setAttribute('id', 'iscam-injected-css');
    style.textContent = `

/* DIAGNOSTIC CANARY — scoped to inv-4-4 only. Remove after testing.
   If you see a red bar at the top of the inv-4-4 page on Runestone,
   this JS-injected CSS IS working. */
#investigation4-4 { border-top: 10px solid red !important; }

/* Allow .ptx-content to be wider so iframes can extend into margins */
.ptx-main .ptx-content {
    max-width: none !important;
    overflow: visible !important;
}

/* But keep text paragraphs at a readable width */
.ptx-content > section > .para,
.ptx-content > section > .paragraphs > .para,
.ptx-content > section > section > .para,
.ptx-content > section > section > .paragraphs > .para,
.ptx-content > section > section > section > .para,
.ptx-content > section > section > section > .paragraphs > .para {
    max-width: 696px;
}

/* Let lists, exercises, articles also stay at readable width */
.ptx-content > section > .exercise-like,
.ptx-content > section > section > .exercise-like,
.ptx-content > section > section > section > .exercise-like,
.ptx-content article.exercise-like {
    max-width: 696px;
}

/* Allow iframes (applets) to be wider than the text column */
.ptx-content iframe {
    max-width: none !important;
}

/* Allow parent containers of iframes to show overflow */
.ptx-content section,
.ptx-content .paragraphs,
.ptx-content figure.figure-like {
    overflow: visible !important;
}

/* Keep content footer at original width */
.ptx-content-footer {
    max-width: 696px;
}

/* Custom styling for convention elements */
.ptx-content article.convention {
    background-color: #f0f8ff !important;
    border-left: 4px solid #4682b4 !important;
    padding: 1em !important;
    margin: 1em 0 !important;
}

.ptx-content article.convention .heading {
    color: #4682b4 !important;
    font-weight: bold !important;
}

/* Reduce spacing between consecutive hint elements */
.ptx-content article.hint + article.hint {
    margin-top: 0.5em !important;
}

/* Reduce spacing after sidebyside elements */
.ptx-content .sidebyside {
    margin-bottom: 0.5em !important;
}

/* Colored backgrounds for definitions, remarks, and assemblages */
.definition-like {
    background-color: #e8f4f8 !important;
    border-left: 4px solid #4a90a4 !important;
    padding: 1em !important;
    border-radius: 4px !important;
    margin-bottom: 1em !important;
}

.remark-like {
    background-color: #fff4e6 !important;
    border-left: 4px solid #ff9800 !important;
    padding: 1em !important;
    border-radius: 4px !important;
    margin-bottom: 1em !important;
}

/* Default assemblage style - light blue for definitions */
.assemblage-like {
    --assemblage-like-body-background: #e8f4f8 !important;
    --assemblage-like-border-color: #4a90a4 !important;
    background-color: #e8f4f8 !important;
    border-left: 4px solid #4a90a4 !important;
    padding: 1em !important;
    border-radius: 4px !important;
    margin-bottom: 1em !important;
}

/* Terminology Detour assemblages - light purple/lavender */
.ptx-content article.assemblage.assemblage-like#def-standard-deviation,
.ptx-content article.assemblage.assemblage-like#def-standardizing,
.ptx-content article.assemblage.assemblage-like#def-random-process,
.ptx-content article.assemblage.assemblage-like#def-sample-space,
.ptx-content article.assemblage.assemblage-like#def-random-variable {
    --assemblage-like-body-background: #f3e5f5 !important;
    --assemblage-like-border-color: #9c27b0 !important;
}

.ptx-content article.assemblage.assemblage-like#def-standard-deviation *,
.ptx-content article.assemblage.assemblage-like#def-standardizing *,
.ptx-content article.assemblage.assemblage-like#def-random-process *,
.ptx-content article.assemblage.assemblage-like#def-sample-space *,
.ptx-content article.assemblage.assemblage-like#def-random-variable * {
    --assemblage-like-body-background: #f3e5f5 !important;
    --assemblage-like-border-color: #9c27b0 !important;
}

/* Force asides to stay in main content area, not margin */
.ptx-content aside.aside-like {
    float: none !important;
    width: 100% !important;
    margin-left: 0 !important;
    margin-right: 0 !important;
    max-width: 696px !important;
}

/* Horizontal rule style for separating sections */
.ptx-content p.horizontal-rule {
    border-top: 2px solid #999 !important;
    margin: 2em 0 !important;
    padding: 0 !important;
    height: 0 !important;
    line-height: 0 !important;
    font-size: 0 !important;
}

/* Remove background and border from Investigation 1.3 Exercise 1 */
.ptx-content #I1-3-1,
.ptx-content article#I1-3-1,
.ptx-content .exercise-like#I1-3-1,
article.exercise-like#I1-3-1 {
    background: none !important;
    background-color: transparent !important;
    border: none !important;
    border-left: none !important;
    box-shadow: none !important;
    padding: 0 !important;
    padding-left: 0 !important;
}

.ptx-content #I1-3-1 .exercise-statement,
.ptx-content #I1-3-1 > * {
    background: none !important;
    background-color: transparent !important;
    border: none !important;
}

/* Add padding to table cells to prevent text from touching borders */
.ptx-content table td,
.ptx-content table th {
    padding: 0.4em 0.6em !important;
}

/* Hide the exercises division heading to avoid double headers */
h3.heading.hide-type,
.ptx-content h3.heading.hide-type,
section.exercises h3.heading.hide-type,
body h3.heading.hide-type,
html body h3.heading.hide-type {
    display: none !important;
    visibility: hidden !important;
    height: 0 !important;
    max-height: 0 !important;
    margin: 0 !important;
    padding: 0 !important;
    overflow: hidden !important;
    line-height: 0 !important;
    font-size: 0 !important;
    opacity: 0 !important;
}

/* Blockquote styling - italic serif for journal excerpts */
.ptx-content blockquote {
    font-family: Georgia, "Times New Roman", serif !important;
    font-style: italic !important;
    border-left: 3px solid #999 !important;
    padding-left: 1.2em !important;
    margin: 1em 2em !important;
    color: #333 !important;
}

    `;
    document.head.appendChild(style);
    console.log('ISCAM: Custom CSS injected via JS');
})();

document.addEventListener('DOMContentLoaded', function() {
    // Movable Applet System - preserves iframe state when moving
    console.log('Setting up movable applet system...');
    
    function moveAppletTo(targetId) {
        const wrap = document.getElementById("applet-wrap");
        const target = document.getElementById(targetId);
        console.log('Attempting to move applet to:', targetId, 'wrap:', wrap, 'target:', target);
        
        if (wrap && target) {
            target.appendChild(wrap); // moving preserves state
            console.log('Applet moved to:', targetId);
            // Scroll to the new location smoothly
            target.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        } else {
            console.error('Could not move applet - missing elements');
        }
    }

    // Set up click handlers for dock buttons
    document.addEventListener("click", function(e) {
        console.log('Click detected on:', e.target);
        
        const btn = e.target.closest(".dock-applet");
        if (btn) {
            console.log('Dock button clicked:', btn);
            e.preventDefault();
            moveAppletTo(btn.dataset.target);
            return;
        }

        if (e.target && e.target.id === "send-home") {
            console.log('Send home button clicked');
            e.preventDefault();
            const home = document.getElementById("applet-home");
            const wrap = document.getElementById("applet-wrap");
            if (home && wrap) {
                home.appendChild(wrap);
                console.log('Applet returned home');
                // Scroll to home location
                home.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }
    });
    
    console.log('Movable applet system initialized');

document.addEventListener('DOMContentLoaded', function() {
    // Find all interactive iframe elements (Runestone renders them in figures or divs)
    const interactives = document.querySelectorAll('.ptx-content iframe[src*="rossmanchance.com/applets"]');
    
    console.log('Found ' + interactives.length + ' applet iframes'); // Debug
    
    if (interactives.length === 0) return;
    
    interactives.forEach(function(iframe) {
        const container = iframe.closest('figure') || iframe.closest('.interactive') || iframe.parentElement;
        container.classList.add('sticky-applet-container');
        
        console.log('Setting up sticky applet for:', iframe.src); // Debug
        
        // Create toggle button
        const toggleBtn = document.createElement('button');
        toggleBtn.className = 'sticky-applet-toggle';
        toggleBtn.textContent = '📊 Show Applet';
        toggleBtn.setAttribute('aria-label', 'Toggle sticky applet');
        document.body.appendChild(toggleBtn);
        
        let isSticky = false;
        let originalParent = null;
        let originalNextSibling = null;
        
        // Toggle sticky state
        function toggleSticky() {
            if (!isSticky) {
                // Save original position
                originalParent = iframe.parentElement;
                originalNextSibling = iframe.nextElementSibling;
                
                // Make sticky
                container.classList.add('is-sticky');
                toggleBtn.textContent = '✕ Hide Applet';
                toggleBtn.classList.add('active');
                isSticky = true;
                
                console.log('Applet is now sticky'); // Debug
            } else {
                // Return to original position
                container.classList.remove('is-sticky');
                toggleBtn.textContent = '📊 Show Applet';
                toggleBtn.classList.remove('active');
                isSticky = false;
                
                console.log('Applet returned to original position'); // Debug
            }
        }
        
        toggleBtn.addEventListener('click', toggleSticky);
        
        // Show/hide button based on scroll position
        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(function(entry) {
                if (entry.isIntersecting) {
                    // Applet is visible, hide button
                    toggleBtn.classList.remove('show');
                    if (isSticky) {
                        toggleSticky(); // Turn off sticky if applet is back in view
                    }
                } else {
                    // Applet scrolled out of view, show button
                    toggleBtn.classList.add('show');
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '-60px 0px 0px 0px'
        });
        
        observer.observe(container);
    });
});
