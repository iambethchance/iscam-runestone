// Sticky Applet JavaScript
// Makes interactive applets float/stick as users scroll

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
