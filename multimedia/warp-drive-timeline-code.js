// Warp Drive Timeline JavaScript Code
// This code defines the timeline data structure and functions to generate and interact with the timeline

// Timeline data structure - Historical progress from 1994-2025
const timelineData = {
    historical: [
        {
            phase: "Historical Progress",
            items: [
                {
                    label: "Alcubierre Metric",
                    category: "Theoretical Physics",
                    start: 1994,
                    end: 1994,
                    color: "#4e76e5",
                    description: "Miguel Alcubierre publishes his groundbreaking paper describing a spacetime metric that would allow for faster-than-light travel without violating special relativity."
                },
                {
                    label: "Van Den Broeck Refinement",
                    category: "Theoretical Physics",
                    start: 1999,
                    end: 2000,
                    color: "#4e76e5",
                    description: "Chris Van Den Broeck proposes modifications to the Alcubierre metric that reduced energy requirements from greater than the mass of the universe to approximately solar mass."
                },
                {
                    label: "Early NASA BPP Program",
                    category: "Experimental Physics",
                    start: 1996,
                    end: 2002,
                    color: "#30bf78",
                    description: "NASA's Breakthrough Propulsion Physics program investigates speculative physics concepts including warp drive theories."
                },
                {
                    label: "Natário Contribution",
                    category: "Theoretical Physics",
                    start: 2002,
                    end: 2002,
                    color: "#4e76e5",
                    description: "José Natário demonstrates that the Alcubierre drive could be modified to avoid the frontal horizon expansion that would capture high-energy particles."
                },
                {
                    label: "Thin-Shell Optimization",
                    category: "Theoretical Physics",
                    start: 2011,
                    end: 2012,
                    color: "#4e76e5",
                    description: "Theoretical work showing that making the bubble walls 'thinner' could dramatically reduce negative energy requirements."
                },
                {
                    label: "White's Energy Calculations",
                    category: "Theoretical Physics",
                    start: 2012,
                    end: 2013,
                    color: "#4e76e5",
                    description: "Harold White at NASA recalculates energy requirements using oscillating bubble geometries, suggesting dramatic reductions in negative energy needs."
                },
                {
                    label: "Early Interferometer Tests",
                    category: "Experimental Physics",
                    start: 2013,
                    end: 2018,
                    color: "#30bf78",
                    description: "White-Juday Warp Field Interferometer experiments at NASA attempt to detect microscopic spacetime distortions created in laboratory conditions."
                },
                {
                    label: "Casimir Effect Experiments",
                    category: "Experimental Physics",
                    start: 2014,
                    end: 2020,
                    color: "#30bf78",
                    description: "Advanced Casimir effect experiments demonstrate sustained negative energy density in increasingly larger regions of space."
                },
                {
                    label: "White-Bobrick Framework",
                    category: "Theoretical Physics",
                    start: 2021,
                    end: 2021,
                    color: "#4e76e5",
                    description: "Alexey Bobrick and Gianni Martire publish a comprehensive classification of all possible warp drives, showing that some sub-light variants might be possible with positive energy."
                },
                {
                    label: "DARPA 'Accidental Bubble'",
                    category: "Experimental Physics",
                    start: 2021,
                    end: 2021,
                    color: "#30bf78",
                    description: "Researchers at Limitless Space Institute accidentally detect what appears to be a microscopic spacetime distortion consistent with a tiny warp bubble during Casimir effect experiments."
                },
                {
                    label: "Soliton Warp Shell Theory",
                    category: "Theoretical Physics",
                    start: 2022,
                    end: 2022,
                    color: "#4e76e5",
                    description: "Development of the soliton-based warp field theory, suggesting self-reinforcing solitary waves could maintain stable warp bubbles with less energy input."
                },
                {
                    label: "Bobrick-Lentz Reconfiguration",
                    category: "Theoretical Physics",
                    start: 2023,
                    end: 2023,
                    color: "#4e76e5",
                    description: "Breakthrough paper proposing modified warp metrics using 'solitonic wave configurations' of positive energy to create effective spacetime distortion without negative energy."
                },
                {
                    label: "Quantum Foam Leverage Hypothesis",
                    category: "Theoretical Physics",
                    start: 2023,
                    end: 2023,
                    color: "#4e76e5",
                    description: "Dr. Viola Chen's team publishes findings suggesting quantum foam might be temporarily 'borrowed against' to create macroscopic negative energy regions."
                },
                {
                    label: "NASA BPP Program Revival",
                    category: "Experimental Physics",
                    start: 2023,
                    end: 2024.5,
                    color: "#30bf78",
                    description: "NASA reestablishes funding for speculative propulsion physics research, including warp drive concepts and experimental tests."
                },
                {
                    label: "Quantum Field Anchoring",
                    category: "Theoretical Physics",
                    start: 2024,
                    end: 2024.5,
                    color: "#4e76e5",
                    description: "Development of quantum field anchoring theory suggesting methods to stabilize warp bubbles using quantum entanglement between the bubble's outer edge and reference frames."
                },
                {
                    label: "Casimir Cavity Array Experiment",
                    category: "Experimental Physics",
                    start: 2024,
                    end: 2024.5,
                    color: "#30bf78",
                    description: "Successful generation of measurable spacetime curvature using an array of nanoscale Casimir cavities combined with electromagnetic fields. The distortion was approximately one billionth of required warp effect."
                }
            ]
        }
    ],
    // Near Term timeline data (2025-2035)
    near: [
        {
            phase: "Near Term (2025-2035)",
            items: [
                {
                    label: "Advanced Metamaterials",
                    category: "Material Science",
                    start: 2025,
                    end: 2030,
                    color: "#f27935",
                    description: "Development of metamaterials with negative refractive index to simulate properties of exotic matter for experimental warp field tests."
                },
                {
                    label: "Quantum Vacuum Manipulation Program",
                    category: "Experimental Physics",
                    start: 2025,
                    end: 2032,
                    color: "#30bf78",
                    description: "Consortium research using advanced Casimir cavity geometries, squeezed quantum states of light, and superconducting metamaterials to create and sustain regions of negative energy density."
                },
                {
                    label: "Spacetime Metrics Collaboration",
                    category: "Theoretical Physics",
                    start: 2025,
                    end: 2035,
                    color: "#4e76e5",
                    description: "International initiative to find 'loopholes' in general relativity permitting viable warp solutions with reduced exotic matter requirements."
                },
                {
                    label: "Applied Quantum Gravity Project",
                    category: "Theoretical Physics",
                    start: 2026,
                    end: 2033,
                    color: "#4e76e5",
                    description: "Research exploring how quantum gravity theories might enable warp effects through manipulation of microscopic spacetime structure."
                },
                {
                    label: "Q-Drive Prototypes",
                    category: "Engineering Development",
                    start: 2027,
                    end: 2034,
                    color: "#d957f8",
                    description: "Development of Quantum Vacuum Plasma Thrusters attempting to leverage quantum vacuum effects for propulsion, generating small but measurable forces."
                },
                {
                    label: "Next-Gen Interferometry",
                    category: "Experimental Physics",
                    start: 2028,
                    end: 2031,
                    color: "#30bf78",
                    description: "Advanced versions of the White-Juday Interferometer with sensitivity to detect spacetime distortions smaller than a proton's width."
                },
                {
                    label: "High-Intensity Field Generators",
                    category: "Engineering Development",
                    start: 2029,
                    end: 2034,
                    color: "#d957f8",
                    description: "Development of ultra-high electromagnetic field generators to test spacetime manipulation theories in laboratory settings."
                }
            ],
            milestones: [
                {
                    position: 2028.5,
                    label: "First Sustained Negative Energy",
                    description: "First laboratory demonstration of sustained negative energy density for more than 1 second in a region larger than molecular scale."
                },
                {
                    position: 2031,
                    label: "Macro Spacetime Distortion",
                    description: "First reproducible macroscopic spacetime distortion measurable with standard equipment, though far too small for propulsion applications."
                },
                {
                    position: 2034,
                    label: "Quantum Vacuum Engineering",
                    description: "Development of reliable methods to engineer quantum vacuum states with specific properties, a fundamental prerequisite for warp field generation."
                }
            ]
        }
    ],
    // Mid Term timeline data (2035-2060)
    mid: [
        {
            phase: "Mid Term (2035-2060)",
            items: [
                {
                    label: "Quantum Gravity Unification",
                    category: "Theoretical Physics",
                    start: 2035,
                    end: 2045,
                    color: "#4e76e5",
                    description: "Theoretical work toward a unified theory of quantum gravity with specific focus on implications for spacetime engineering and warp physics."
                },
                {
                    label: "Exotic Matter Synthesis",
                    category: "Material Science",
                    start: 2036,
                    end: 2048,
                    color: "#f27935",
                    description: "Research into creating stable materials with exotic properties like negative mass-energy density through advanced quantum vacuum manipulation techniques."
                },
                {
                    label: "Warp Field Stabilization",
                    category: "Theoretical Physics",
                    start: 2038,
                    end: 2047,
                    color: "#4e76e5",
                    description: "Development of mathematical frameworks to ensure stable warp bubbles that don't collapse catastrophically once formed."
                },
                {
                    label: "Sub-light Warp Field Tests",
                    category: "Experimental Physics",
                    start: 2040,
                    end: 2052,
                    color: "#30bf78",
                    description: "Laboratory experiments testing limited 'sub-light' warp field technologies that distort spacetime without achieving FTL capabilities."
                },
                {
                    label: "Micro-Warp Bubble Prototype",
                    category: "Engineering Development",
                    start: 2042,
                    end: 2055,
                    color: "#d957f8",
                    description: "Engineering work to create the first microscopic but stable warp bubble capable of moving test particles with measurable spacetime distortion effects."
                },
                {
                    label: "Warp Field Control Systems",
                    category: "Engineering Development",
                    start: 2045,
                    end: 2058,
                    color: "#d957f8",
                    description: "Development of precise control systems capable of initiating, maintaining, and safely collapsing experimental warp fields."
                },
                {
                    label: "Bubble Geometry Optimization",
                    category: "Theoretical Physics",
                    start: 2048,
                    end: 2055,
                    color: "#4e76e5",
                    description: "Refinement of warp bubble geometry to minimize exotic matter requirements and maximize stability across varying energy conditions."
                }
            ],
            milestones: [
                {
                    position: 2043,
                    label: "Laboratory Warp Effect",
                    description: "First demonstration of a proper 'warp effect' where spacetime itself is manipulated to move an object, even if only at microscopic scales."
                },
                {
                    position: 2050,
                    label: "Warp Field Propagation",
                    description: "First controlled propagation of a stable warp field moving at measurable velocity through laboratory apparatus."
                },
                {
                    position: 2058,
                    label: "Macroscopic Transport",
                    description: "First macroscopic object (>1cm) transported using limited warp field technology, potentially enabling revolutionary sub-light propulsion systems."
                }
            ]
        }
    ],
    // Long Term timeline data (2060+)
    far: [
        {
            phase: "Long Term (2060+)",
            items: [
                {
                    label: "Warp Probe Development",
                    category: "Engineering Development",
                    start: 2060,
                    end: 2068,
                    color: "#d957f8",
                    description: "Engineering program to develop the first instrumented probe capable of surviving inside a warp bubble for scientific measurements."
                },
                {
                    label: "Causality Protection Protocols",
                    category: "Theoretical Physics",
                    start: 2062,
                    end: 2070,
                    color: "#4e76e5",
                    description: "Theoretical and practical work to ensure FTL warp technology cannot create causality paradoxes that violate physical laws."
                },
                {
                    label: "Interstellar Communication",
                    category: "Engineering Development",
                    start: 2065,
                    end: 2075,
                    color: "#d957f8",
                    description: "Application of limited warp field technology to enable near-instantaneous communication with distant spacecraft through quantum entanglement enhanced by spacetime manipulation."
                },
                {
                    label: "Full-Scale Warp Drive",
                    category: "Engineering Development",
                    start: 2070,
                    end: 2080,
                    color: "#d957f8",
                    description: "Development of the first full-scale warp drive capable of transporting significant mass (>1 ton) through a stable warp bubble."
                },
                {
                    label: "Solar System Warp Transit",
                    category: "Engineering Development",
                    start: 2075,
                    end: 2080,
                    color: "#d957f8",
                    description: "Development of first practical warp transit system for rapid transport between distant points in the solar system, reducing travel times from years to days."
                }
            ],
            milestones: [
                {
                    position: 2065,
                    label: "First Warp Bubble Transport",
                    description: "First experimental transport of a probe within a true warp bubble, potentially achieving speeds exceeding conventional limits."
                },
                {
                    position: 2073,
                    label: "FTL Milestone",
                    description: "First potential demonstration of apparent faster-than-light effect through spacetime manipulation rather than conventional motion."
                },
                {
                    position: 2080,
                    label: "Interstellar Capability",
                    description: "Development of theoretical capability to reach nearby stars within human timescales, pending resolution of remaining engineering challenges."
                }
            ]
        }
    ]
};

// Function to generate the timeline HTML based on selected date range and phases
function generateTimelineHTML(startYear, endYear, phases) {
    // Calculate date ranges and grid
    const yearRange = endYear - startYear;
    const yearWidth = 100 / yearRange; // percentage width for each year
    
    let timelineHTML = '';
    
    // Generate year markers
    timelineHTML += '<div class="timeline-header">';
    for (let year = startYear; year <= endYear; year++) {
        timelineHTML += `<div class="year-marker">${year}</div>`;
    }
    timelineHTML += '</div>';
    
    // Generate timeline content for each phase
    phases.forEach(phase => {
        timelineHTML += `<h2 class="phase-header">${phase.phase}</h2>`;
        
        // Generate timeline items
        phase.items.forEach(item => {
            const startPosition = ((item.start - startYear) / yearRange) * 100;
            const endPosition = ((item.end - startYear) / yearRange) * 100;
            const width = endPosition - startPosition;
            
            timelineHTML += `
                <div class="timeline-item">
                    <div class="timeline-label">${item.label} <span class="category-label">${item.category}</span></div>
                    <div class="timeline-bar-container">
                        <div class="timeline-grid">
                            ${Array(yearRange + 1).fill().map(() => '<div class="grid-line"></div>').join('')}
                        </div>
                        <div class="timeline-bar" 
                            style="left: ${startPosition}%; width: ${width}%; background-color: ${item.color};"
                            onmouseover="showTooltip(event, '${item.label}', '${item.description}')"
                            onmouseout="hideTooltip()">
                            ${item.label}
                        </div>
                    </div>
                </div>
            `;
        });
        
        // Generate milestones if they exist
        if (phase.milestones) {
            timelineHTML += '<div class="timeline-item">';
            timelineHTML += '<div class="timeline-label">Milestones</div>';
            timelineHTML += '<div class="timeline-bar-container">';
            timelineHTML += '<div class="timeline-grid">';
            for (let i = 0; i <= yearRange; i++) {
                timelineHTML += '<div class="grid-line"></div>';
            }
            timelineHTML += '</div>';
            
            // Add milestone markers
            phase.milestones.forEach(milestone => {
                const position = ((milestone.position - startYear) / yearRange) * 100;
                timelineHTML += `
                    <div class="milestone" 
                        style="left: ${position}%;"
                        onmouseover="showTooltip(event, '${milestone.label}', '${milestone.description}')"
                        onmouseout="hideTooltip()">
                    </div>
                `;
            });
            
            timelineHTML += '</div></div>';
        }
    });
    
    return timelineHTML;
}

// Function to create and show tooltip when hovering over timeline elements
function showTooltip(event, title, description) {
    // Remove any existing tooltips
    const existingTooltip = document.querySelector('.tooltip');
    if (existingTooltip) {
        existingTooltip.remove();
    }
    
    const tooltip = document.createElement('div');
    tooltip.className = 'tooltip';
    tooltip.innerHTML = `<strong>${title}</strong><br>${description}`;
    document.body.appendChild(tooltip);
    
    // Position the tooltip
    const rect = event.target.getBoundingClientRect();
    tooltip.style.top = `${rect.top - tooltip.offsetHeight - 10}px`;
    tooltip.style.left = `${rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2)}px`;
    
    // Make it visible
    setTimeout(() => {
        tooltip.style.visibility = 'visible';
        tooltip.style.opacity = '1';
    }, 10);
}

// Function to hide tooltip when no longer hovering
function hideTooltip() {
    const tooltip = document.querySelector('.tooltip');
    if (tooltip) {
        tooltip.style.opacity = '0';
        setTimeout(() => {
            tooltip.remove();
        }, 300);
    }
}

// Function to change timeline focus based on button selection
function focusTimeline(focus) {
    const container = document.getElementById('timeline-container');
    const timeFocus = document.getElementById('time-focus');
    
    let timelineHTML = '';
    let startYear, endYear, phases;
    
    switch(focus) {
        case 'past':
            startYear = 1994;
            endYear = 2025;
            phases = timelineData.historical;
            timeFocus.textContent = 'Historical Progress (1994-2025)';
            break;
        case 'near':
            startYear = 2025;
            endYear = 2035;
            phases = timelineData.near;
            timeFocus.textContent = 'Near Term (2025-2035)';
            break;
        case 'mid':
            startYear = 2035;
            endYear = 2060;
            phases = timelineData.mid;
            timeFocus.textContent = 'Mid Term (2035-2060)';
            break;
        case 'far':
            startYear = 2060;
            endYear = 2080;
            phases = timelineData.far;
            timeFocus.textContent = 'Long Term (2060+)';
            break;
        case 'all':
        default:
            startYear = 1994;
            endYear = 2080;
            phases = [...timelineData.historical, ...timelineData.near, ...timelineData.mid, ...timelineData.far];
            timeFocus.textContent = 'Full Timeline View (1994-2080)';
            break;
    }
    
    timelineHTML = generateTimelineHTML(startYear, endYear, phases);
    container.innerHTML = timelineHTML;
}

// Initialize the timeline with all phases on load
document.addEventListener('DOMContentLoaded', () => {
    focusTimeline('all');
});