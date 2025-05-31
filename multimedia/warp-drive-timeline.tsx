import { useState, useEffect, useRef } from 'react';

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
          description: "Consortium research using advanced Casimir cavity geometries, squeezed quantum states of light, and superconducting metamaterials to create and sustain regions of negative energy density.",
          milestones: [
            {
              position: 2028.5,
              label: "First Sustained Negative Energy",
              description: "First laboratory demonstration of sustained negative energy density for more than 1 second in a region larger than molecular scale."
            }
          ]
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
          description: "Development of Quantum Vacuum Plasma Thrusters attempting to leverage quantum vacuum effects for propulsion, generating small but measurable forces.",
          milestones: [
            {
              position: 2034,
              label: "Quantum Vacuum Engineering",
              description: "Development of reliable methods to engineer quantum vacuum states with specific properties, a fundamental prerequisite for warp field generation."
            }
          ]
        },
        {
          label: "Next-Gen Interferometry",
          category: "Experimental Physics",
          start: 2028,
          end: 2031,
          color: "#30bf78",
          description: "Advanced versions of the White-Juday Interferometer with sensitivity to detect spacetime distortions smaller than a proton's width.",
          milestones: [
            {
              position: 2031,
              label: "Macro Spacetime Distortion",
              description: "First reproducible macroscopic spacetime distortion measurable with standard equipment, though far too small for propulsion applications."
            }
          ]
        },
        {
          label: "High-Intensity Field Generators",
          category: "Engineering Development",
          start: 2029,
          end: 2034,
          color: "#d957f8",
          description: "Development of ultra-high electromagnetic field generators to test spacetime manipulation theories in laboratory settings."
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
          description: "Laboratory experiments testing limited 'sub-light' warp field technologies that distort spacetime without achieving FTL capabilities.",
          milestones: [
            {
              position: 2043,
              label: "Laboratory Warp Effect",
              description: "First demonstration of a proper 'warp effect' where spacetime itself is manipulated to move an object, even if only at microscopic scales."
            }
          ]
        },
        {
          label: "Micro-Warp Bubble Prototype",
          category: "Engineering Development",
          start: 2042,
          end: 2055,
          color: "#d957f8",
          description: "Engineering work to create the first microscopic but stable warp bubble capable of moving test particles with measurable spacetime distortion effects.",
          milestones: [
            {
              position: 2050,
              label: "Warp Field Propagation",
              description: "First controlled propagation of a stable warp field moving at measurable velocity through laboratory apparatus."
            }
          ]
        },
        {
          label: "Warp Field Control Systems",
          category: "Engineering Development",
          start: 2045,
          end: 2058,
          color: "#d957f8",
          description: "Development of precise control systems capable of initiating, maintaining, and safely collapsing experimental warp fields.",
          milestones: [
            {
              position: 2058,
              label: "Macroscopic Transport",
              description: "First macroscopic object (>1cm) transported using limited warp field technology, potentially enabling revolutionary sub-light propulsion systems."
            }
          ]
        },
        {
          label: "Bubble Geometry Optimization",
          category: "Theoretical Physics",
          start: 2048,
          end: 2055,
          color: "#4e76e5",
          description: "Refinement of warp bubble geometry to minimize exotic matter requirements and maximize stability across varying energy conditions."
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
          description: "Engineering program to develop the first instrumented probe capable of surviving inside a warp bubble for scientific measurements.",
          milestones: [
            {
              position: 2065,
              label: "First Warp Bubble Transport",
              description: "First experimental transport of a probe within a true warp bubble, potentially achieving speeds exceeding conventional limits."
            }
          ]
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
          description: "Development of the first full-scale warp drive capable of transporting significant mass (>1 ton) through a stable warp bubble.",
          milestones: [
            {
              position: 2073,
              label: "FTL Milestone",
              description: "First potential demonstration of apparent faster-than-light effect through spacetime manipulation rather than conventional motion."
            }
          ]
        },
        {
          label: "Solar System Warp Transit",
          category: "Engineering Development",
          start: 2075,
          end: 2080,
          color: "#d957f8",
          description: "Development of first practical warp transit system for rapid transport between distant points in the solar system, reducing travel times from years to days.",
          milestones: [
            {
              position: 2080,
              label: "Interstellar Capability",
              description: "Development of theoretical capability to reach nearby stars within human timescales, pending resolution of remaining engineering challenges."
            }
          ]
        }
      ]
    }
  ]
};

// Literary quotes to enhance the timeline
const literaryQuotes = {
  alcubierre: "Remember Alcubierre? 1994—mathematics dancing on the edge of reality, equations carving tunnels through the fabric we call Now.",
  warpBubble: "Contract the space ahead, expand what lies behind, create a bubble of flat spacetime—a surfboard on the quantum ocean.",
  negativeEnergy: "Negative energy, exotic matter, the universe's forbidden ingredients hidden in the Casimir effect, quantum foam bubbling beneath reality.",
  timeline: "The timeline stretches before us: 1994-2024: Theory and whispered possibilities, 2025-2035: Microscopic bubbles, negative energy sustained, 2035-2060: First warp effects in laboratory conditions, Beyond 2060: The stars no longer out of reach",
  possibility: "And though the stars still seem distant, their light taking years to reach us, the quantum whispers grow louder: The impossible is merely difficult; the difficult merely takes time.",
  conclusion: "So when you look up at the night sky, remember—there's a folded path between here and there, waiting for us to learn its secrets."
};

function WarpDriveTimeline() {
  const [focus, setFocus] = useState('all');
  const [tooltipData, setTooltipData] = useState(null);
  const [timelineConfig, setTimelineConfig] = useState({
    startYear: 1994,
    endYear: 2080,
    phases: [...timelineData.historical, ...timelineData.near, ...timelineData.mid, ...timelineData.far]
  });
  const [isInitialRender, setIsInitialRender] = useState(true);
  const containerRef = useRef(null);

  // Current year for highlighting
  const currentYear = 2025;
  
  // Update timeline configuration when focus changes
  useEffect(() => {
    let startYear, endYear, phases;
    
    switch(focus) {
      case 'past':
        startYear = 1994;
        endYear = 2025;
        phases = timelineData.historical;
        break;
      case 'near':
        startYear = 2025;
        endYear = 2035;
        phases = timelineData.near;
        break;
      case 'mid':
        startYear = 2035;
        endYear = 2060;
        phases = timelineData.mid;
        break;
      case 'far':
        startYear = 2060;
        endYear = 2080;
        phases = timelineData.far;
        break;
      case 'all':
      default:
        startYear = 1994;
        endYear = 2080;
        phases = [...timelineData.historical, ...timelineData.near, ...timelineData.mid, ...timelineData.far];
        break;
    }
    
    if (isInitialRender) {
      setTimelineConfig({ startYear, endYear, phases });
      setIsInitialRender(false);
    } else {
      // Animate the transition between different timeline views
      const container = containerRef.current;
      if (container) {
        container.style.opacity = 0;
        container.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
          setTimelineConfig({ startYear, endYear, phases });
          container.style.opacity = 1;
          container.style.transform = 'translateY(0)';
        }, 300);
      } else {
        setTimelineConfig({ startYear, endYear, phases });
      }
    }
  }, [focus, isInitialRender]);

  // Show tooltip with item information
  const showTooltip = (event, item) => {
    const rect = event.target.getBoundingClientRect();
    
    setTooltipData({
      title: item.label,
      category: item.category,
      description: item.description,
      quote: getRelevantQuote(item),
      position: {
        top: rect.top - 10,
        left: rect.left + (rect.width / 2)
      }
    });
  };

  // Hide tooltip
  const hideTooltip = () => {
    setTooltipData(null);
  };

  // Get a relevant literary quote based on the item's characteristics
  const getRelevantQuote = (item) => {
    const label = item.label.toLowerCase();
    const description = item.description.toLowerCase();

    if (label.includes('alcubierre') || description.includes('alcubierre')) {
      return literaryQuotes.alcubierre;
    } else if (label.includes('bubble') || description.includes('bubble')) {
      return literaryQuotes.warpBubble;
    } else if (label.includes('energy') || description.includes('energy') || 
               label.includes('exotic') || description.includes('exotic')) {
      return literaryQuotes.negativeEnergy;
    } else if (label.includes('star') || description.includes('star') || 
               label.includes('ftl') || description.includes('ftl')) {
      return literaryQuotes.possibility;
    }
    
    // Default quote for items that don't match specific criteria
    return "";
  };

  // Generate year markers for the timeline header
  const renderYearMarkers = () => {
    const { startYear, endYear } = timelineConfig;
    const years = [];
    
    for (let year = startYear; year <= endYear; year++) {
      years.push(
        <div 
          key={year} 
          className={`year-marker ${year === currentYear ? 'current-year' : ''}`}
        >
          {year}
        </div>
      );
    }
    
    return years;
  };

  // Calculate position and width of timeline items
  const calculateTimelineItemStyle = (item) => {
    const { startYear, endYear } = timelineConfig;
    const yearRange = endYear - startYear;
    
    const startPosition = ((item.start - startYear) / yearRange) * 100;
    const endPosition = ((item.end - startYear) / yearRange) * 100;
    const width = endPosition - startPosition;
    
    return {
      left: `${startPosition}%`,
      width: `${width}%`,
      backgroundColor: item.color,
    };
  };

  // Calculate position of milestones on their parent bar
  const calculateMilestonePositionOnBar = (milestone, parentItem) => {
    const { startYear, endYear } = timelineConfig;
    const yearRange = endYear - startYear;
    
    // Calculate relative position within the parent bar
    const parentStartPos = ((parentItem.start - startYear) / yearRange) * 100;
    const parentEndPos = ((parentItem.end - startYear) / yearRange) * 100;
    const parentWidth = parentEndPos - parentStartPos;
    
    const milestonePos = ((milestone.position - startYear) / yearRange) * 100;
    // Calculate position relative to parent bar's left edge
    const relativePos = ((milestonePos - parentStartPos) / parentWidth) * 100;
    
    return {
      left: `${relativePos}%`,
    };
  };

  // Render timeline items for a phase
  const renderTimelineItems = (phase) => {
    return phase.items.map((item, index) => {
      const itemStyle = calculateTimelineItemStyle(item);
      const isHistorical = item.end < currentYear;
      const isCurrent = item.start <= currentYear && item.end >= currentYear;
      const isProjected = item.start > currentYear;
      
      // Calculate animation delay based on item index
      const delay = index * 100;
      
      return (
        <div key={`${phase.phase}-${index}`} className="timeline-item">
          <div className="timeline-label">
            {item.label} 
            <span className="category-label">{item.category}</span>
          </div>
          <div className="timeline-bar-container">
            <div className="timeline-grid">
              {Array(timelineConfig.endYear - timelineConfig.startYear + 1).fill().map((_, i) => (
                <div key={i} className="grid-line"></div>
              ))}
            </div>
            {isCurrent && <div className="present-line"></div>}
            <div 
              className={`timeline-bar ${isHistorical ? 'historical' : ''} ${isProjected ? 'projected' : ''}`}
              style={{
                ...itemStyle,
                animationDelay: `${delay}ms`
              }}
              onMouseEnter={(e) => showTooltip(e, item)}
              onMouseLeave={hideTooltip}
            >
              {item.label}
              
              {/* Render milestones directly on the timeline bar if they exist */}
              {item.milestones && item.milestones.map((milestone, milestoneIndex) => {
                const milestonePos = calculateMilestonePositionOnBar(milestone, item);
                const milestoneDelay = (index * 100) + (milestoneIndex * 100) + 500;
                
                return (
                  <div 
                    key={`milestone-${item.label}-${milestoneIndex}`}
                    className="milestone milestone-on-bar"
                    style={{
                      left: milestonePos.left,
                      animationDelay: `${milestoneDelay}ms`
                    }}
                    onMouseEnter={(e) => showTooltip(e, { 
                      label: milestone.label, 
                      category: "Milestone", 
                      description: milestone.description 
                    })}
                    onMouseLeave={hideTooltip}
                  ></div>
                );
              })}
            </div>
          </div>
        </div>
      );
    });
  };

  // Render milestones for a phase - this is now only used for historical milestones
  const renderMilestones = (phase) => {
    // Skip rendering if no milestones at phase level (they're now embedded in timeline items)
    if (!phase.milestones || phase.milestones.length === 0) return null;
    
    return (
      <div className="timeline-item">
        <div className="timeline-label">Milestones</div>
        <div className="timeline-bar-container">
          <div className="timeline-grid">
            {Array(timelineConfig.endYear - timelineConfig.startYear + 1).fill().map((_, i) => (
              <div key={i} className="grid-line"></div>
            ))}
          </div>
          
          {phase.milestones.map((milestone, index) => {
            // Use the regular milestone position calculation for standalone milestones
            const { startYear, endYear } = timelineConfig;
            const yearRange = endYear - startYear;
            const position = ((milestone.position - startYear) / yearRange) * 100;
            const milestoneStyle = { left: `${position}%` };
            const delay = (phase.items.length + index) * 100 + 300;
            
            return (
              <div 
                key={`milestone-${index}`}
                className="milestone"
                style={{
                  ...milestoneStyle,
                  animationDelay: `${delay}ms`
                }}
                onMouseEnter={(e) => showTooltip(e, { 
                  label: milestone.label, 
                  category: "Milestone", 
                  description: milestone.description 
                })}
                onMouseLeave={hideTooltip}
              ></div>
            );
          })}
        </div>
      </div>
    );
  };

  return (
    <div className="warp-drive-timeline" style={{ animation: 'fadeIn 1s ease-out' }}>
      <h1 className="animate-title">The Young Explorer's Warp Drive Development Timeline</h1>
      <p className="intro-text animate-text">
        <em>This interactive timeline illustrates the theoretical and experimental pathways toward warp drive technology, from past achievements to projected future milestones.</em>
      </p>
      
      <div className="controls animate-controls">
        <button className={`control-btn ${focus === 'past' ? 'active' : ''}`} onClick={() => setFocus('past')}>Historical Progress</button>
        <button className={`control-btn ${focus === 'near' ? 'active' : ''}`} onClick={() => setFocus('near')}>Near Term (2025-2035)</button>
        <button className={`control-btn ${focus === 'mid' ? 'active' : ''}`} onClick={() => setFocus('mid')}>Mid Term (2035-2060)</button>
        <button className={`control-btn ${focus === 'far' ? 'active' : ''}`} onClick={() => setFocus('far')}>Long Term (2060+)</button>
        <button className={`control-btn ${focus === 'all' ? 'active' : ''}`} onClick={() => setFocus('all')}>View All</button>
      </div>
      
      <div className="time-focus animate-focus">
        {focus === 'past' && 'Historical Progress (1994-2025)'}
        {focus === 'near' && 'Near Term (2025-2035)'}
        {focus === 'mid' && 'Mid Term (2035-2060)'}
        {focus === 'far' && 'Long Term (2060+)'}
        {focus === 'all' && 'Full Timeline View (1994-2080)'}
      </div>
      
      <div className="timeline-container" ref={containerRef}>
        <div className="timeline-header animate-header">
          {renderYearMarkers()}
        </div>
        
        {timelineConfig.phases.map((phase, phaseIndex) => (
          <div key={`phase-${phaseIndex}`} className="phase-section">
            <h2 className="phase-header" style={{ animationDelay: `${phaseIndex * 200}ms` }}>
              {phase.phase}
            </h2>
            {renderTimelineItems(phase)}
            {renderMilestones(phase)}
          </div>
        ))}
      </div>
      
      {tooltipData && (
        <div
          className="tooltip"
          style={{
            position: 'absolute',
            top: `${tooltipData.position.top}px`,
            left: `${tooltipData.position.left}px`,
            transform: 'translate(-50%, -100%)',
            animation: 'tooltipFadeIn 0.2s ease forwards'
          }}
        >
          <div className="tooltip-title">{tooltipData.title}</div>
          <div className="tooltip-category">{tooltipData.category}</div>
          <div className="tooltip-description">{tooltipData.description}</div>
          {tooltipData.quote && (
            <div className="tooltip-quote">"{tooltipData.quote}"</div>
          )}
        </div>
      )}
      
      <div className="legend animate-legend">
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#4e76e5' }}></div>
          <span>Theoretical Physics</span>
        </div>
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#30bf78' }}></div>
          <span>Experimental Physics</span>
        </div>
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#d957f8' }}></div>
          <span>Engineering Development</span>
        </div>
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#f27935' }}></div>
          <span>Material Science</span>
        </div>
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#ffcc00' }}></div>
          <span>Milestone</span>
        </div>
      </div>

      <style jsx>{`
        .warp-drive-timeline {
          font-family: 'Arial', sans-serif;
          background-color: #0a1128;
          color: #e2e2e2;
          padding: 20px;
          border-radius: 10px;
          max-width: 100%;
          overflow-x: hidden;
          position: relative;
          background-image: 
            radial-gradient(circle at 10% 20%, rgba(50, 100, 255, 0.05) 0%, transparent 40%),
            radial-gradient(circle at 90% 60%, rgba(50, 100, 255, 0.05) 0%, transparent 40%);
        }
        
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        
        h1 {
          text-align: center;
          color: #7b9fff;
          margin-bottom: 30px;
          font-size: 28px;
          text-shadow: 0 0 10px rgba(100, 150, 255, 0.3);
          animation: fadeInDown 1s forwards;
        }
        
        @keyframes fadeInDown {
          from {
            opacity: 0;
            transform: translateY(-20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        .intro-text {
          margin-bottom: 25px;
          line-height: 1.5;
          text-align: center;
          color: #aac4ff;
          animation: fadeIn 1s forwards;
          animation-delay: 0.3s;
          opacity: 0;
        }
        
        .controls {
          display: flex;
          justify-content: center;
          margin-bottom: 20px;
          flex-wrap: wrap;
          gap: 10px;
          animation: fadeIn 1s forwards;
          animation-delay: 0.5s;
          opacity: 0;
        }
        
        .control-btn {
          background-color: #1a2649;
          color: #aac4ff;
          border: 1px solid #3d5a9d;
          padding: 10px 20px;
          border-radius: 4px;
          cursor: pointer;
          transition: all 0.3s;
          position: relative;
          overflow: hidden;
        }
        
        .control-btn::after {
          content: '';
          position: absolute;
          top: 0;
          left: -100%;
          width: 100%;
          height: 100%;
          background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
          transition: left 0.5s;
        }
        
        .control-btn:hover {
          background-color: #263563;
          color: white;
          transform: translateY(-2px);
          box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .control-btn:hover::after {
          left: 100%;
        }
        
        .control-btn.active {
          background-color: #3d5a9d;
          color: white;
          box-shadow: 0 0 15px rgba(123, 159, 255, 0.3);
        }
        
        .time-focus {
          text-align: center;
          margin-bottom: 20px;
          font-weight: bold;
          color: #7b9fff;
          font-size: 18px;
          animation: fadeIn 1s forwards;
          animation-delay: 0.7s;
          opacity: 0;
        }
        
        .timeline-container {
          position: relative;
          margin-bottom: 40px;
          transition: opacity 0.3s, transform 0.3s;
        }
        
        .timeline-header {
          display: flex;
          margin-bottom: 10px;
          padding-left: 200px;
          position: sticky;
          top: 0;
          background-color: rgba(10, 17, 40, 0.95);
          z-index: 10;
          padding-top: 10px;
          padding-bottom: 10px;
          backdrop-filter: blur(5px);
          animation: fadeIn 1s forwards;
          animation-delay: 0.9s;
          opacity: 0;
        }
        
        .year-marker {
          flex: 1;
          text-align: center;
          font-weight: bold;
          color: #7b9fff;
          font-size: 12px;
          transition: color 0.3s;
        }
        
        .current-year {
          color: #ffcc00;
          position: relative;
        }
        
        .current-year::after {
          content: '';
          position: absolute;
          left: 50%;
          top: 100%;
          transform: translateX(-50%);
          width: 1px;
          height: 0;
          background-color: rgba(255, 204, 0, 0.2);
          animation: currentYearLine 2s forwards;
          z-index: 1;
        }
        
        @keyframes currentYearLine {
          0% { height: 0; }
          100% { height: 500px; }
        }
        
        .phase-header {
          margin-top: 40px;
          margin-bottom: 15px;
          color: #7b9fff;
          font-size: 20px;
          border-bottom: 1px solid #3d5a9d;
          padding-bottom: 5px;
          opacity: 0;
          transform: translateY(20px);
          animation: fadeIn 0.8s forwards;
        }
        
        .timeline-item {
          display: flex;
          margin-bottom: 15px;
          align-items: center;
        }
        
        .timeline-label {
          width: 200px;
          padding-right: 15px;
          text-align: right;
          font-weight: bold;
          color: #e2e2e2;
        }
        
        .category-label {
          font-style: italic;
          color: #aac4ff;
          margin-left: 5px;
          font-size: 0.8em;
        }
        
        .timeline-bar-container {
          flex: 1;
          display: flex;
          height: 30px;
          position: relative;
        }
        
        .timeline-grid {
          display: flex;
          position: absolute;
          width: 100%;
          height: 100%;
          pointer-events: none;
        }
        
        .grid-line {
          flex: 1;
          border-right: 1px dashed rgba(123, 159, 255, 0.2);
          height: 100%;
        }
        
        .timeline-bar {
          height: 100%;
          border-radius: 4px;
          transition: all 0.3s ease;
          position: absolute;
          display: flex;
          align-items: center;
          justify-content: center;
          color: white;
          font-size: 12px;
          cursor: pointer;
          overflow: hidden;
          white-space: nowrap;
          text-overflow: ellipsis;
          padding: 0 10px;
          box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
          opacity: 0;
          transform: translateY(20px);
          animation: fadeInUp 0.5s ease forwards;
        }
        
        @keyframes fadeInUp {
          from {
            opacity: 0;
            transform: translateY(20px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }
        
        .timeline-bar:hover {
          transform: translateY(-2px);
          box-shadow: 0 4px 8px rgba(0, 0, 0, 0.5);
          z-index: 10;
        }
        
        .historical {
          border: none;
        }
        
        .projected {
          background-image: linear-gradient(45deg, 
            rgba(255, 255, 255, 0.1) 25%, 
            transparent 25%, 
            transparent 50%, 
            rgba(255, 255, 255, 0.1) 50%, 
            rgba(255, 255, 255, 0.1) 75%, 
            transparent 75%, 
            transparent);
          background-size: 15px 15px;
          border: 1px dashed rgba(255, 255, 255, 0.3);
          animation: moveStripes 30s linear infinite;
        }
        
        @keyframes moveStripes {
          from { background-position: 0 0; }
          to { background-position: 100px 0; }
        }
        
        .present-line {
          position: absolute;
          left: 0;
          width: 100%;
          height: 1px;
          background-color: #ffcc00;
          top: 50%;
          transform: translateY(-50%);
          z-index: 1;
          pointer-events: none;
        }
        
        .milestone {
          position: absolute;
          width: 15px;
          height: 15px;
          background-color: #ffcc00;
          border-radius: 50%;
          bottom: -20px;
          transform: translateX(-50%) scale(0);
          cursor: pointer;
          z-index: 5;
          box-shadow: 0 0 10px rgba(255, 204, 0, 0.5);
          animation: pulseIn 0.5s forwards;
        }
        
        /* Milestone positioned directly on timeline bar */
        .milestone-on-bar {
          bottom: auto;
          top: 50%;
          transform: translate(-50%, -50%) scale(0);
          animation: pulseInCentered 0.5s forwards;
        }
        
        @keyframes pulseInCentered {
          0% {
            transform: translate(-50%, -50%) scale(0);
            opacity: 0;
          }
          50% {
            transform: translate(-50%, -50%) scale(1.2);
            opacity: 1;
          }
          100% {
            transform: translate(-50%, -50%) scale(1);
            opacity: 1;
          }
        }
        
        @keyframes pulseIn {
          0% {
            transform: translateX(-50%) scale(0);
            opacity: 0;
          }
          50% {
            transform: translateX(-50%) scale(1.2);
            opacity: 1;
          }
          100% {
            transform: translateX(-50%) scale(1);
            opacity: 1;
          }
        }
        
        .milestone::after {
          content: '';
          position: absolute;
          width: 100%;
          height: 100%;
          border-radius: 50%;
          background-color: rgba(255, 204, 0, 0.4);
          animation: pulse 2s infinite;
          left: 0;
          top: 0;
        }
        
        @keyframes pulse {
          0% {
            transform: scale(1);
            opacity: 0.7;
          }
          50% {
            transform: scale(1.5);
            opacity: 0;
          }
          100% {
            transform: scale(1);
            opacity: 0;
          }
        }
        
        .milestone:hover {
          transform: translateX(-50%) scale(1.2);
        }
        
        .tooltip {
          background-color: rgba(10, 17, 40, 0.95);
          color: #fff;
          padding: 15px;
          border-radius: 5px;
          box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
          z-index: 100;
          width: 250px;
          font-size: 14px;
          border: 1px solid #3d5a9d;
          pointer-events: none;
          opacity: 0;
          backdrop-filter: blur(5px);
        }
        
        @keyframes tooltipFadeIn {
          from {
            opacity: 0;
            transform: translate(-50%, -90%);
          }
          to {
            opacity: 1;
            transform: translate(-50%, -100%);
          }
        }
        
        .tooltip-title {
          color: #7b9fff;
          font-weight: bold;
          margin-bottom: 5px;
          font-size: 16px;
          border-bottom: 1px solid rgba(123, 159, 255, 0.3);
          padding-bottom: 5px;
        }
        
        .tooltip-category {
          color: #aac4ff;
          font-style: italic;
          margin-bottom: 5px;
          font-size: 12px;
        }
        
        .tooltip-description {
          margin-bottom: 10px;
          line-height: 1.4;
        }
        
        .tooltip-quote {
          font-style: italic;
          border-left: 3px solid #7b9fff;
          padding-left: 10px;
          margin-top: 10px;
          color: #aac4ff;
        }
        
        .legend {
          display: flex;
          justify-content: center;
          flex-wrap: wrap;
          margin-top: 30px;
          gap: 15px;
          opacity: 0;
          animation: fadeIn 1s forwards;
          animation-delay: 1s;
        }
        
        .legend-item {
          display: flex;
          align-items: center;
          margin-right: 15px;
          transition: transform 0.3s;
        }
        
        .legend-item:hover {
          transform: translateY(-2px);
        }
        
        .legend-color {
          width: 20px;
          height: 20px;
          border-radius: 4px;
          margin-right: 5px;
          box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        
        .animate-title {
          opacity: 0;
          animation: fadeInDown 1s forwards;
        }
        
        .animate-text {
          opacity: 0;
          animation: fadeIn 1s forwards;
          animation-delay: 0.3s;
        }
        
        .animate-controls {
          opacity: 0;
          animation: fadeIn 1s forwards;
          animation-delay: 0.5s;
        }
        
        .animate-focus {
          opacity: 0;
          animation: fadeIn 1s forwards;
          animation-delay: 0.7s;
        }
        
        .animate-header {
          opacity: 0;
          animation: fadeIn 1s forwards;
          animation-delay: 0.9s;
        }
                
        @media (max-width: 768px) {
          .timeline-label {
            width: 150px;
            font-size: 12px;
          }
          
          .control-btn {
            font-size: 12px;
            padding: 6px 10px;
          }
          
          .timeline-bar {
            font-size: 10px;
          }
        }
      `}</style>
    </div>
  );
}

export default WarpDriveTimeline;