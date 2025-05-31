import React, { useState, useRef, useEffect } from 'react'

const SymphonyVisualizer = () => {
  const canvasRef = useRef(null)
  const [activeSchools, setActiveSchools] = useState({
    celestialChorus: true,
    earthsong: false,
    voidFrequency: false,
    discord: false
  })

  const schools = {
    celestialChorus: {
      name: 'Celestial Chorus',
      color: '#4a90e2',
      frequency: 2,
      amplitude: 50,
      description: 'Pure stellar harmonies, flowing in perfect resonance'
    },
    earthsong: {
      name: 'Earthsong Circle',
      color: '#50c878',
      frequency: 1.5,
      amplitude: 40,
      description: 'Grounded rhythms that pulse with natural life'
    },
    voidFrequency: {
      name: 'Void Frequencies',
      color: '#9932cc',
      frequency: 3,
      amplitude: 30,
      description: 'The song between songs, gaps in conventional harmony'
    },
    discord: {
      name: 'Discord',
      color: '#dc143c',
      frequency: 4,
      amplitude: 45,
      description: 'Chaotic energies that break and reshape patterns'
    }
  }

  useEffect(() => {
    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')
    let animationFrameId
    let time = 0

    const drawWave = (time) => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      const centerY = canvas.height / 2

      Object.entries(activeSchools).forEach(([school, isActive]) => {
        if (!isActive) return

        const schoolData = schools[school]
        ctx.beginPath()
        ctx.strokeStyle = schoolData.color
        ctx.lineWidth = 2

        for (let x = 0; x < canvas.width; x++) {
          let y = centerY

          if (school === 'voidFrequency') {
            // Void frequencies have gaps
            if (Math.sin(x * 0.05 + time) > 0.7) {
              continue
            }
          }

          // Base wave
          y += Math.sin(x * schoolData.frequency * 0.01 + time) * schoolData.amplitude

          if (school === 'discord') {
            // Discord adds chaotic elements
            y += Math.tan(Math.sin(x * 0.02 + time)) * 10
          }

          if (x === 0) {
            ctx.moveTo(x, y)
          } else {
            ctx.lineTo(x, y)
          }
        }

        ctx.stroke()

        // Add glow effect
        ctx.save()
        ctx.filter = 'blur(4px)'
        ctx.strokeStyle = schoolData.color + '80'
        ctx.lineWidth = 4
        ctx.stroke()
        ctx.restore()
      })
    }

    const animate = () => {
      time += 0.02
      drawWave(time)
      animationFrameId = window.requestAnimationFrame(animate)
    }

    animate()

    return () => {
      window.cancelAnimationFrame(animationFrameId)
    }
  }, [activeSchools])

  return (
    <div className="w-full max-w-4xl mx-auto p-6 bg-gray-900 rounded-lg shadow-xl">
      <h2 className="text-2xl font-bold text-white mb-4">Symphony Visualizer</h2>
      
      <div className="mb-6 grid grid-cols-2 gap-4">
        {Object.entries(schools).map(([key, school]) => (
          <div 
            key={key}
            className="flex items-center space-x-4 bg-gray-800 p-4 rounded-lg"
          >
            <button
              className={`w-6 h-6 rounded-full border-2 ${
                activeSchools[key] 
                  ? `bg-${school.color} border-${school.color}` 
                  : 'bg-transparent border-gray-400'
              }`}
              onClick={() => setActiveSchools(prev => ({
                ...prev,
                [key]: !prev[key]
              }))}
            />
            <div>
              <h3 className="text-white font-semibold">{school.name}</h3>
              <p className="text-gray-400 text-sm">{school.description}</p>
            </div>
          </div>
        ))}
      </div>

      <div className="relative">
        <canvas
          ref={canvasRef}
          width={800}
          height={300}
          className="w-full h-64 bg-gray-800 rounded-lg"
        />
      </div>
    </div>
  )
}

export default SymphonyVisualizer