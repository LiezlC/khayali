import React, { useState } from 'react'
import { Sparkles } from 'lucide-react'

const HarmonistsTower = () => {
  const [activeLevel, setActiveLevel] = useState(null)
  const [voidFrequencies, setVoidFrequencies] = useState(false)

  const levels = [
    {
      name: 'Stellar Harmonies',
      color: 'bg-indigo-500',
      description: 'The highest frequencies, connecting to star songs and cosmic rhythms',
      elements: ['Dark Star Gates', 'Stellar Currents', 'Cosmic Symphony'],
      frequency: 'text-indigo-200'
    },
    {
      name: 'Planetary Resonance',
      color: 'bg-purple-500',
      description: 'Harmonies of celestial bodies within our system',
      elements: ['Moon Tides', 'Planet Songs', 'Solar Frequencies'],
      frequency: 'text-purple-200'
    },
    {
      name: 'Upper Atmosphere',
      color: 'bg-blue-500',
      description: 'Where celestial and terrestrial frequencies meet',
      elements: ['Aurora Harmonics', 'Storm Frequencies', 'Wind Songs'],
      frequency: 'text-blue-200'
    },
    {
      name: 'Terrestrial Harmonies',
      color: 'bg-green-500',
      description: 'Earth-bound frequencies of nature and life',
      elements: ['Earth Rhythms', 'Life Songs', 'Crystal Resonance'],
      frequency: 'text-green-200'
    },
    {
      name: 'Deep Resonance',
      color: 'bg-amber-500',
      description: 'Fundamental frequencies from the planet\'s core',
      elements: ['Core Harmonics', 'Magma Songs', 'Stone Frequencies'],
      frequency: 'text-amber-200'
    }
  ]

  const VoidFrequencyLayer = ({ level }) => (
    <div className="absolute inset-0 bg-purple-900 bg-opacity-20 z-10 overflow-hidden">
      <div className="relative w-full h-full">
        {[...Array(5)].map((_, i) => (
          <div
            key={i}
            className="absolute bg-purple-500 opacity-10"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              width: '2px',
              height: '40%',
              transform: `rotate(${Math.random() * 360}deg)`,
              animation: `pulse ${2 + Math.random() * 2}s infinite`
            }}
          />
        ))}
      </div>
    </div>
  )

  return (
    <div className="w-full max-w-4xl mx-auto p-6 bg-gray-900 rounded-lg shadow-xl">
      <div className="flex justify-between items-center mb-6">
        <h2 className="text-2xl font-bold text-white">The Harmonist&apos;s Tower</h2>
        <button
          onClick={() => setVoidFrequencies(!voidFrequencies)}
          className={`px-4 py-2 rounded-lg flex items-center gap-2 ${
            voidFrequencies ? 'bg-purple-700 text-white' : 'bg-gray-700 text-gray-200'
          }`}
        >
          <Sparkles size={16} />
          Void Frequencies
        </button>
      </div>

      <div className="relative space-y-4">
        {levels.map((level, index) => (
          <div
            key={index}
            className={`relative ${level.color} p-4 rounded-lg transition-all duration-300 cursor-pointer
              ${activeLevel === index ? 'scale-105 z-20' : 'hover:scale-102'}`}
            onClick={() => setActiveLevel(activeLevel === index ? null : index)}
          >
            {voidFrequencies && <VoidFrequencyLayer level={index} />}
            <div className="relative z-20">
              <div className="flex justify-between items-start">
                <h3 className="text-xl font-semibold text-white">{level.name}</h3>
                <div className={`text-sm ${level.frequency}`}>
                  ~{Math.pow(10, 5 - index)}Hz
                </div>
              </div>
              
              {activeLevel === index && (
                <div className="mt-4 space-y-2">
                  <p className="text-white/80">{level.description}</p>
                  <div className="grid grid-cols-3 gap-2 mt-2">
                    {level.elements.map((element, i) => (
                      <div
                        key={i}
                        className="bg-black/20 rounded px-3 py-1 text-sm text-white/90"
                      >
                        {element}
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>

      <style jsx>{`
        @keyframes pulse {
          0%, 100% { opacity: 0.1; }
          50% { opacity: 0.3; }
        }
      `}</style>
    </div>
  )
}

export default HarmonistsTower