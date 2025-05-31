import React, { useState, useRef, useEffect } from 'react'
import { Volume2, VolumeX, Music } from 'lucide-react'

const HarmonicsInteractionLayer = ({ 
  width, 
  height, 
  activeZones, 
  mousePosition,
  cityZones 
}) => {
  const canvasRef = useRef(null)

  const drawHarmonicInteraction = (ctx, timestamp) => {
    ctx.clearRect(0, 0, width, height)

    // Create interference patterns between active zones
    const activeZonesList = Object.entries(activeZones)
      .filter(([_, strength]) => strength > 0)
      .map(([id]) => ({
        ...cityZones[id],
        strength: activeZones[id]
      }))

    if (activeZonesList.length > 0) {
      // Create gradient overlay for harmonic interference
      const imageData = ctx.createImageData(width, height)
      const data = imageData.data

      for (let x = 0; x < width; x += 2) { // Skip pixels for performance
        for (let y = 0; y < height; y += 2) {
          const index = (y * width + x) * 4
          let totalAmplitude = 0
          let frequencies = []

          // Calculate combined wave effects from each active zone
          activeZonesList.forEach(zone => {
            const dx = x - zone.position.x
            const dy = y - zone.position.y
            const distance = Math.sqrt(dx * dx + dy * dy)
            
            const frequency = zone.baseFreq / 100
            const phase = timestamp * 0.001
            const amplitude = Math.max(0, 1 - distance / 200) * zone.strength

            totalAmplitude += amplitude
            frequencies.push({
              freq: frequency,
              amp: amplitude,
              phase: phase,
              color: zone.color
            })
          })

          if (totalAmplitude > 0) {
            let r = 0, g = 0, b = 0, a = 0
            
            frequencies.forEach(freq => {
              const wave = Math.sin(
                freq.freq * (x + y) + freq.phase
              ) * freq.amp
              
              const color = freq.color.match(/[A-Za-z0-9]{2}/g)
                ?.map(v => parseInt(v, 16)) || [0, 0, 0]
              
              r += color[0] * wave
              g += color[1] * wave
              b += color[2] * wave
              a += 255 * freq.amp
            })

            // Fill 2x2 pixel blocks for performance
            for (let dx = 0; dx < 2; dx++) {
              for (let dy = 0; dy < 2; dy++) {
                const idx = ((y + dy) * width + (x + dx)) * 4
                if (idx < data.length - 3) {
                  data[idx] = Math.abs(r)
                  data[idx + 1] = Math.abs(g)
                  data[idx + 2] = Math.abs(b)
                  data[idx + 3] = Math.min(a * 0.5, 255)
                }
              }
            }
          }
        }
      }

      ctx.putImageData(imageData, 0, 0)

      // Draw resonance lines
      ctx.lineWidth = 2
      activeZonesList.forEach((zone1, i) => {
        activeZonesList.slice(i + 1).forEach(zone2 => {
          const freq1 = zone1.baseFreq
          const freq2 = zone2.baseFreq
          const ratio = freq1 / freq2
          
          if (Math.abs(ratio - Math.round(ratio)) < 0.1) {
            ctx.beginPath()
            ctx.strokeStyle = `rgba(255, 255, 255, ${
              (zone1.strength + zone2.strength) * 0.3
            })`
            
            const points = 20
            for (let i = 0; i <= points; i++) {
              const t = i / points
              const x = zone1.position.x + (zone2.position.x - zone1.position.x) * t
              const y = zone1.position.y + (zone2.position.y - zone1.position.y) * t
              
              const wave = Math.sin(t * Math.PI * 4 + timestamp * 0.001) * 10
              const dx = -(zone2.position.y - zone1.position.y)
              const dy = (zone2.position.x - zone1.position.x)
              const len = Math.sqrt(dx * dx + dy * dy)
              
              if (i === 0) {
                ctx.moveTo(x + dx / len * wave, y + dy / len * wave)
              } else {
                ctx.lineTo(x + dx / len * wave, y + dy / len * wave)
              }
            }
            
            ctx.stroke()
          }
        })
      })
    }
  }

  useEffect(() => {
    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')
    let animationFrame

    const animate = (timestamp) => {
      drawHarmonicInteraction(ctx, timestamp)
      animationFrame = requestAnimationFrame(animate)
    }

    animate(0)
    return () => cancelAnimationFrame(animationFrame)
  }, [activeZones, mousePosition])

  return (
    <canvas
      ref={canvasRef}
      width={width}
      height={height}
      className="absolute top-0 left-0 pointer-events-none"
      style={{ mixBlendMode: 'screen' }}
    />
  )
}

const EnhancedResonaraMap = () => {
  const [audioContext, setAudioContext] = useState(null)
  const [isAudioEnabled, setIsAudioEnabled] = useState(false)
  const [activeZone, setActiveZone] = useState(null)
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 })
  const [showFrequencyViz, setShowFrequencyViz] = useState(false)
  const [oscillators, setOscillators] = useState({})
  const canvasRef = useRef(null)
  const frequencyCanvasRef = useRef(null)

  const cityZones = {
    crystalSpire: {
      name: 'Crystal Spire',
      color: '#4a90e2',
      baseFreq: 528,
      harmonics: [528 * 1.5, 528 * 2, 528 * 0.5],
      description: 'Central harmonic nexus of the city',
      position: { x: 400, y: 150 },
      radius: 50
    },
    nightsongAcademy: {
      name: 'Nightsong Academy',
      color: '#9932cc',
      baseFreq: 432,
      harmonics: [432 * 1.5, 432 * 2, 432 * 0.75],
      description: 'Where harmonists train in frequency manipulation',
      position: { x: 200, y: 250 },
      radius: 40
    },
    grandAmphitheater: {
      name: 'Grand Amphitheater',
      color: '#50c878',
      baseFreq: 396,
      harmonics: [396 * 1.5, 396 * 2, 396 * 0.66],
      description: 'Public performance space for harmonic arts',
      position: { x: 600, y: 250 },
      radius: 45
    },
    harmonicExchange: {
      name: 'Grand Harmonic Exchange',
      color: '#ffd700',
      baseFreq: 417,
      harmonics: [417 * 1.5, 417 * 2, 417 * 0.8],
      description: 'Central transportation and commerce hub',
      position: { x: 400, y: 350 },
      radius: 55
    },
    silentQuarter: {
      name: 'Silent Quarter',
      color: '#8b0000',
      baseFreq: 369,
      harmonics: [369 * 1.5, 369 * 2, 369 * 0.9],
      description: 'District where void frequencies manifest',
      position: { x: 300, y: 450 },
      radius: 35
    },
    resonancePark: {
      name: 'Resonance Park',
      color: '#228b22',
      baseFreq: 444,
      harmonics: [444 * 1.5, 444 * 2, 444 * 0.7],
      description: 'Natural harmony gardens and meditation spaces',
      position: { x: 500, y: 450 },
      radius: 35
    }
  }

  const calculateDistance = (pos1, pos2) => {
    const dx = pos1.x - pos2.x
    const dy = pos1.y - pos2.y
    return Math.sqrt(dx * dx + dy * dy)
  }

  const initAudio = async () => {
    const context = new (window.AudioContext || window.webkitAudioContext)()
    setAudioContext(context)

    const masterGain = context.createGain()
    masterGain.gain.setValueAtTime(0.3, context.currentTime)
    masterGain.connect(context.destination)

    const newOscillators = {}
    
    Object.entries(cityZones).forEach(([key, zone]) => {
      const zoneOscillators = []
      
      // Create base frequency oscillator
      const baseOsc = context.createOscillator()
      const baseGain = context.createGain()
      const baseFilter = context.createBiquadFilter()
      
      baseOsc.type = 'sine'
      baseOsc.frequency.setValueAtTime(zone.baseFreq, context.currentTime)
      
      baseFilter.type = 'bandpass'
      baseFilter.frequency.setValueAtTime(zone.baseFreq, context.currentTime)
      baseFilter.Q.setValueAtTime(10, context.currentTime)
      
      baseGain.gain.setValueAtTime(0, context.currentTime)
      
      baseOsc.connect(baseFilter)
      baseFilter.connect(baseGain)
      baseGain.connect(masterGain)
      
      baseOsc.start()
      zoneOscillators.push({ osc: baseOsc, gain: baseGain, filter: baseFilter })

      // Create harmonic oscillators
      zone.harmonics.forEach(freq => {
        const harmOsc = context.createOscillator()
        const harmGain = context.createGain()
        
        harmOsc.type = 'sine'
        harmOsc.frequency.setValueAtTime(freq, context.currentTime)
        
        harmGain.gain.setValueAtTime(0, context.currentTime)
        
        harmOsc.connect(harmGain)
        harmGain.connect(masterGain)
        
        harmOsc.start()
        zoneOscillators.push({ osc: harmOsc, gain: harmGain })
      })

      newOscillators[key] = zoneOscillators
    })
    
    setOscillators(newOscillators)
    setIsAudioEnabled(true)
  }

  const toggleAudio = () => {
    if (!audioContext) {
      initAudio()
    } else {
      if (isAudioEnabled) {
        Object.values(oscillators).forEach(oscillatorGroup => {
          oscillatorGroup.forEach(({ gain }) => {
            gain.gain.setValueAtTime(0, audioContext.currentTime)
          })
        })
      }
      setIsAudioEnabled(!isAudioEnabled)
    }
  }

  const updateAudio = () => {
    if (!audioContext || !isAudioEnabled) return

    Object.entries(cityZones).forEach(([key, zone]) => {
      const distance = calculateDistance(mousePosition, zone.position)
      const isActive = key === activeZone
      const volume = Math.max(0, 1 - (distance / 200)) + (isActive ? 0.5 : 0)
      
      oscillators[key]?.forEach((osc, index) => {
        const targetGain = volume * (index === 0 ? 0.3 : 0.1)
        osc.gain.gain.setTargetAtTime(targetGain, audioContext.currentTime, 0.1)
      })
    })
  }

  useEffect(() => {
    updateAudio()
  }, [mousePosition, activeZone, isAudioEnabled])

  const handleMouseMove = (event) => {
    const canvas = canvasRef.current
    const rect = canvas.getBoundingClientRect()
    setMousePosition({
      x: event.clientX - rect.left,
      y: event.clientY - rect.top
    })
  }

  // Draw the main city map
  useEffect(() => {
    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')
    let animationFrame

    const drawMap = (timestamp) => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)

      // Draw connection lines between Crystal Spire and other locations
      ctx.beginPath()
      ctx.strokeStyle = '#2a2a3a'
      ctx.lineWidth = 10
      Object.values(cityZones).forEach(zone => {
        if (zone.name !== 'Crystal Spire') {
          ctx.moveTo(cityZones.crystalSpire.position.x, cityZones.crystalSpire.position.y)
          ctx.lineTo(zone.position.x, zone.position.y)
        }
      })
      ctx.stroke()

      // Draw harmonic flow lines
      ctx.lineWidth = 2
      Object.values(cityZones).forEach(zone => {
        if (zone.name !== 'Crystal Spire') {
          ctx.beginPath()
          ctx.strokeStyle = `${zone.color}40`
          const flowOffset = (timestamp || 0) * 0.001
          ctx.setLineDash([10, 10])
          ctx.lineDashOffset = -flowOffset * 20
          ctx.moveTo(cityZones.crystalSpire.position.x, cityZones.crystalSpire.position.y)
          ctx.lineTo(zone.position.x, zone.position.y)
          ctx.stroke()
          ctx.setLineDash([])
        }
      })

      // Draw zones
      Object.entries(cityZones).forEach(([key, zone]) => {
        const isActive = key === activeZone
        const isHovered = calculateDistance(mousePosition, zone.position) < zone.radius

        // Resonance circles
        const pulseSize = Math.sin(timestamp * 0.002) * 5
        const currentRadius = zone.radius + (isActive || isHovered ? pulseSize : 0)

        // Outer glow
        ctx.beginPath()
        ctx.fillStyle = `${zone.color}20`
        ctx.strokeStyle = zone.color
        ctx.lineWidth = isActive ? 3 : 1
        ctx.arc(zone.position.x, zone.position.y, currentRadius + 10, 0, Math.PI * 2)
        ctx.fill()
        ctx.stroke()

        // Inner circle
        ctx.beginPath()
        ctx.fillStyle = `${zone.color}40`
        ctx.arc(zone.position.x, zone.position.y, currentRadius, 0, Math.PI * 2)
        ctx.fill()
        ctx.stroke()

        // Zone label
        ctx.fillStyle = '#ffffff'
        ctx.font = `${isActive ? 'bold ' : ''}14px Arial`
        ctx.textAlign = 'center'
        ctx.fillText(zone.name, zone.position.x, zone.position.y + zone.radius + 20)
      })

      animationFrame = requestAnimationFrame(drawMap)
    }

    drawMap()
    return () => cancelAnimationFrame(animationFrame)
  }, [activeZone, mousePosition])

  useEffect(() => {
    return () => {
      if (audioContext) {
        Object.values(oscillators).forEach(oscillatorGroup => {
          oscillatorGroup.forEach(({ osc, gain }) => {
            osc.stop()
            osc.disconnect()
            gain.disconnect()
          })
        })
      }
    }
  }, [])

  return (
    <div className="w-full max-w-4xl mx-auto p-6 bg-gray-900 rounded-lg shadow-xl">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-2xl font-bold text-white">Resonara City Map</h2>
        <div className="flex gap-2">
          <button
            onClick={() => setShowFrequencyViz(!showFrequencyViz)}
            className={`p-2 rounded-lg ${
              showFrequencyViz ? 'bg-purple-600' : 'bg-gray-600'
            }`}
          >
            <Music className="text-white" size={24} />
          </button>
          <button
            onClick={toggleAudio}
            className={`p-2 rounded-lg ${
              isAudioEnabled ? 'bg-green-600' : 'bg-gray-600'
            }`}
          >
            {isAudioEnabled ? (
              <Volume2 className="text-white" size={24} />
            ) : (
              <VolumeX className="text-white" size={24} />
            )}
          </button>
        </div>
      </div>

      <div className="relative mb-4">
        <canvas
          ref={canvasRef}
          width={800}
          height={500}
          className="w-full bg-gray-800 rounded-lg cursor-pointer"
          onClick={(e) => {
            const rect = canvasRef.current.getBoundingClientRect()
            const x = e.clientX - rect.left
            const y = e.clientY - rect.top
            setMousePosition({ x, y })
            
            const clickedZone = Object.entries(cityZones).find(([_, zone]) => {
              return calculateDistance({ x, y }, zone.position) <= zone.radius
            })
            setActiveZone(clickedZone ? clickedZone[0] : null)
          }}
          onMouseMove={handleMouseMove}
        />
        
        <HarmonicsInteractionLayer
          width={800}
          height={500}
          activeZones={Object.fromEntries(
            Object.entries(cityZones).map(([key, zone]) => {
              const distance = calculateDistance(mousePosition, zone.position)
              const isActive = key === activeZone
              const strength = Math.max(
                0,
                1 - (distance / 200)
              ) + (isActive ? 0.5 : 0)
              return [key, strength]
            })
          )}
          mousePosition={mousePosition}
          cityZones={cityZones}
        />
        
        {showFrequencyViz && (
          <canvas
            ref={frequencyCanvasRef}
            width={800}
            height={150}
            className="w-full bg-gray-800 rounded-lg mt-4"
          />
        )}
      </div>

      <div className="bg-gray-800 p-4 rounded-lg">
        <h3 className="text-white font-semibold mb-2">
          {activeZone ? cityZones[activeZone].name : 'Select a location'}
        </h3>
        <p className="text-gray-400">
          {activeZone 
            ? cityZones[activeZone].description 
            : 'Move mouse over the map to blend harmonies, click to focus on a zone'}
        </p>
        {activeZone && (
          <p className="text-gray-400 mt-2">
            Base Frequency: {cityZones[activeZone].baseFreq}Hz
          </p>
        )}
      </div>
    </div>
  )
}

export default EnhancedResonaraMap