// Sticky Applet JavaScript
// Makes interactive applets float/stick as users scroll

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
