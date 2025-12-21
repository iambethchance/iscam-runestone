// Sticky Applet JavaScript
// Makes interactive applets float/stick as users scroll

document.addEventListener('DOMContentLoaded', function() {
    // Find all interactive elements that should be sticky
    const interactives = document.querySelectorAll('.interactive[data-sticky="true"]');
    
    if (interactives.length === 0) return;
    
    interactives.forEach(function(interactive) {
        const container = interactive.closest('figure') || interactive.parentElement;
        container.classList.add('sticky-applet-container');
        
        // Create toggle button
        const toggleBtn = document.createElement('button');
        toggleBtn.className = 'sticky-applet-toggle';
        toggleBtn.textContent = '📊 Show Applet';
        toggleBtn.setAttribute('aria-label', 'Toggle sticky applet');
        document.body.appendChild(toggleBtn);
        
        let isSticky = false;
        let originalPosition = null;
        
        // Toggle sticky state
        function toggleSticky() {
            if (!isSticky) {
                // Save original position
                originalPosition = {
                    parent: interactive.parentElement,
                    nextSibling: interactive.nextElementSibling
                };
                
                // Make sticky
                container.classList.add('is-sticky');
                toggleBtn.textContent = '✕ Hide Applet';
                isSticky = true;
            } else {
                // Return to original position
                container.classList.remove('is-sticky');
                if (originalPosition) {
                    if (originalPosition.nextSibling) {
                        originalPosition.parent.insertBefore(interactive, originalPosition.nextSibling);
                    } else {
                        originalPosition.parent.appendChild(interactive);
                    }
                }
                toggleBtn.textContent = '📊 Show Applet';
                isSticky = false;
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
            threshold: 0.1
        });
        
        observer.observe(container);
    });
});
