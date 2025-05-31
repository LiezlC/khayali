import React, { useState, useEffect, useRef } from 'react';

const FrequencyVisualizer = () => {
  const [activeFrequency, setActiveFrequency] = useState('harmonic');
  const [amplitude, setAmplitude] = useState(50);
  const [frequency, setFrequency] = useState(2);
  const [complexity, setComplexity] = useState(1);
  const [colorScheme, setColorScheme] = useState('blue');
  const canvasRef = useRef(null);
  const animationRef = useRef(null);
  const [time, setTime] = useState(0);
  
  // Color schemes for different frequency types
  const colorSchemes = {
    blue: ['#0066cc', '#66ccff'],
    green: ['#006633', '#00cc66'],
    purple: ['#330066', '#9933cc'],
    gold: ['#cc9900', '#ffcc00'],
    red: ['#990000', '#ff3333'],
    void: ['#330033', '#cc33cc'],
  };
  
  // Map frequency types to colors
  const frequencyColors = {
    harmonic: 'blue',
    terrestrial: 'green', 
    stellar: 'purple',
    planetary: 'gold',
    dissonant: 'red',
    void: 'void'
  };
  
  // Descriptions for each frequency type
  const frequencyDescriptions = {
    harmonic: "Harmonic frequencies stabilize and enhance existing patterns. Used for healing, protection, and amplification of natural phenomena.",
    terrestrial: "Earth-based frequencies connect with elements and life forces. Common in agriculture, healing, and weather manipulation.",
    stellar: "The highest form of frequency manipulation, drawing power from stars. Requires exceptional attunement and used for the most powerful workings.",
    planetary: "Frequencies that tap into planetary bodies, creating effects based on traditional planetary correspondences.",
    dissonant: "Disruptive frequencies that can break down existing harmonies. Potentially dangerous but powerful for defensive or offensive applications.",
    void: "The mysterious frequencies found in the Silent Deserts, representing the spaces between conventional harmonies. Few can hear or manipulate these."
  };

  useEffect(() => {
    // Update color scheme when frequency type changes
    setColorScheme(frequencyColors[activeFrequency]);
  }, [activeFrequency]);

  useEffect(() => {
    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    const width = canvas.width;
    const height = canvas.height;
    
    const render = () => {
      // Clear canvas
      ctx.clearRect(0, 0, width, height);
      
      // Create gradient based on active color scheme
      const colors = colorSchemes[colorScheme];
      const gradient = ctx.createLinearGradient(0, 0, 0, height);
      gradient.addColorStop(0, colors[0]);
      gradient.addColorStop(1, colors[1]);
      
      // Draw waveform based on frequency type
      ctx.beginPath();
      ctx.moveTo(0, height / 2);
      
      for (let x = 0; x < width; x++) {
        let y = height / 2;
        
        // Base wave
        const baseWave = Math.sin((x / width) * Math.PI * 2 * frequency + time) * amplitude;
        y += baseWave;
        
        // Add complexity for different frequency types
        if (activeFrequency === 'harmonic') {
          // Smooth, regular waves
          y += Math.sin((x / width) * Math.PI * 4 * frequency + time) * (amplitude * 0.2 * complexity);
        } else if (activeFrequency === 'terrestrial') {
          // More grounded, fluctuating waves
          y += Math.sin((x / width) * Math.PI * 3 * frequency + time * 0.7) * (amplitude * 0.3 * complexity);
          y += Math.cos((x / width) * Math.PI * 1.5 * frequency + time * 0.5) * (amplitude * 0.15 * complexity);
        } else if (activeFrequency === 'stellar') {
          // Higher frequency, more complex patterns
          y += Math.sin((x / width) * Math.PI * 6 * frequency + time * 1.2) * (amplitude * 0.25 * complexity);
          y += Math.sin((x / width) * Math.PI * 8 * frequency + time * 0.8) * (amplitude * 0.15 * complexity);
          y += Math.cos((x / width) * Math.PI * 10 * frequency + time * 1.5) * (amplitude * 0.1 * complexity);
        } else if (activeFrequency === 'planetary') {
          // Resonant, orbit-like patterns
          y += Math.sin((x / width) * Math.PI * 2.5 * frequency + time * 0.9) * (amplitude * 0.3 * complexity);
          y += Math.cos((x / width) * Math.PI * 5 * frequency + time * 0.4) * (amplitude * 0.2 * complexity);
        } else if (activeFrequency === 'dissonant') {
          // Jagged, disruptive patterns
          y += Math.tan(Math.sin((x / width) * Math.PI * 3 * frequency + time) * 0.2) * (amplitude * 0.4 * complexity);
          y += Math.sin((x / width) * Math.PI * 7 * frequency + time * 1.1) * (amplitude * 0.25 * complexity);
          // Keep dissonant waves from going off-canvas
          y = Math.max(10, Math.min(height - 10, y));
        } else if (activeFrequency === 'void') {
          // Strange, "impossible" patterns with gaps
          if (Math.sin((x / width) * Math.PI * frequency * 2 + time * 0.5) > 0.7) {
            // Create "gaps" in the wave
            y = height / 2;
          } else {
            y += Math.sin((x / width) * Math.PI * 2 * frequency + time * 0.7) * (amplitude * 0.3 * complexity);
            y += Math.cos((x / width) * Math.PI * 5 * frequency + time * 1.3) * (amplitude * 0.4 * complexity);
            if (Math.cos((x / width) * Math.PI * 10 + time) > 0.8) {
              y += Math.sin((x / width) * Math.PI * 20 * frequency + time * 2) * (amplitude * 0.5 * complexity);
            }
          }
        }
        
        ctx.lineTo(x, y);
      }
      
      // Style and stroke the path
      ctx.strokeStyle = gradient;
      ctx.lineWidth = 3;
      ctx.stroke();
      
      // Add glow effect
      ctx.save();
      ctx.filter = `blur(8px)`;
      ctx.strokeStyle = colors[1];
      ctx.lineWidth = 5;
      ctx.stroke();
      ctx.restore();
      
      // Animate
      setTime(prevTime => prevTime + 0.05);
      animationRef.current = requestAnimationFrame(render);
    };
    
    render();
    
    return () => {
      cancelAnimationFrame(animationRef.current);
    };
  }, [activeFrequency, amplitude, frequency, complexity, colorScheme, time]);

  return (
    <div className="flex flex-col items-center w-full p-4 bg-gray-900 text-white rounded-lg">
      <h2 className="text-2xl font-bold mb-4">Harmonic Frequency Visualizer</h2>
      
      <div className="w-full mb-6">
        <canvas 
          ref={canvasRef} 
          width={800} 
          height={300} 
          className="w-full h-64 bg-gray-800 rounded-lg border border-gray-700"
        />
      </div>
      
      <div className="w-full mb-4 p-4 bg-gray-800 rounded-lg">
        <h3 className="text-xl mb-2 font-semibold">{activeFrequency.charAt(0).toUpperCase() + activeFrequency.slice(1)} Frequency</h3>
        <p className="text-gray-300 mb-4">{frequencyDescriptions[activeFrequency]}</p>
      </div>
      
      <div className="w-full grid grid-cols-2 gap-4 mb-6">
        <div className="flex flex-col">
          <label className="mb-1 text-gray-300">Frequency Type</label>
          <div className="grid grid-cols-3 gap-2">
            {Object.keys(frequencyColors).map(type => (
              <button
                key={type}
                className={`py-2 px-3 rounded ${activeFrequency === type ? 'bg-blue-600' : 'bg-gray-700'}`}
                onClick={() => setActiveFrequency(type)}
              >
                {type.charAt(0).toUpperCase() + type.slice(1)}
              </button>
            ))}
          </div>
        </div>
        
        <div className="flex flex-col">
          <label className="mb-1 text-gray-300">Controls</label>
          <div className="grid grid-cols-1 gap-4">
            <div>
              <label className="block text-sm">Amplitude: {amplitude}</label>
              <input
                type="range"
                min="10"
                max="100"
                value={amplitude}
                onChange={(e) => setAmplitude(parseInt(e.target.value))}
                className="w-full"
              />
            </div>
            
            <div>
              <label className="block text-sm">Base Frequency: {frequency}</label>
              <input
                type="range"
                min="1"
                max="5"
                step="0.1"
                value={frequency}
                onChange={(e) => setFrequency(parseFloat(e.target.value))}
                className="w-full"
              />
            </div>
            
            <div>
              <label className="block text-sm">Complexity: {complexity}</label>
              <input
                type="range"
                min="0.5"
                max="3"
                step="0.1"
                value={complexity}
                onChange={(e) => setComplexity(parseFloat(e.target.value))}
                className="w-full"
              />
            </div>
          </div>
        </div>
      </div>
      
      <div className="w-full p-4 bg-gray-800 rounded-lg text-sm">
        <p className="text-gray-300">
          In the world of Harmonica, practitioners learn to sense and manipulate these fundamental frequencies that underlie reality. 
          Experiment with different frequency types, amplitudes, and complexities to visualize how various forms of harmonic magic might appear.
        </p>
      </div>
    </div>
  );
};

export default FrequencyVisualizer;