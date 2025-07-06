import React, { useEffect, useState } from 'react';
import './App.css';
import { sinnohPokemon, typeChart } from './pokedex';

function App() {
  const [pokemonOptions, setPokemonOptions] = useState([]);
  const [selectedPokemon1, setSelectedPokemon1] = useState('');
  const [selectedPokemon2, setSelectedPokemon2] = useState('');
  const [pokemon1Data, setPokemon1Data] = useState(null);
  const [pokemon2Data, setPokemon2Data] = useState(null);
  const [hp1, setHp1] = useState(100);
  const [hp2, setHp2] = useState(100);
  const [calculationText, setCalculationText] = useState('');
  const [turnCounterText, setTurnCounterText] = useState('');
  const [isToggled, setIsToggled] = useState(false);
  const [isToggled2, setIsToggled2] = useState(true);
  useEffect(() => {
    const fetchPokemonOptions = () => {
      const options = Object.values(sinnohPokemon).map(pokemon => ({
        name: pokemon.name,
        value: pokemon.name,
      }));
      setPokemonOptions(options);
    };
    fetchPokemonOptions();
  }, []);

  useEffect(() => {
    if (selectedPokemon1) {
      fetchPokemonData(selectedPokemon1, 'pokemon1');
    }
  }, [selectedPokemon1]);

  useEffect(() => {
    if (selectedPokemon2) {
      fetchPokemonData(selectedPokemon2, 'pokemon2');
    }
  }, [selectedPokemon2]);

  const fetchPokemonData = async (pokemonName, pokemonType) => {
    try {
      const response = await fetch(`https://pokeapi.co/api/v2/pokemon/${pokemonName.toLowerCase()}`);
      const data = await response.json();

      if (pokemonType === 'pokemon1') {
        setPokemon1Data(data);
      } else if (pokemonType === 'pokemon2') {
        setPokemon2Data(data);
      }
    } catch (error) {
      console.error(`Error fetching data for ${pokemonName}:`, error);
    }
  };

  const handlePokemonChange = (pokemonType, event) => {
    if (pokemonType === 'pokemon1') {
      setSelectedPokemon1(event.target.value);
    } else if (pokemonType === 'pokemon2') {
      setSelectedPokemon2(event.target.value);
    }
  };
  const handleChange = () => {
    setIsToggled(prev => !prev);
    setIsToggled2(prev => !prev);
  };
  const handleAttack = async (attackerType, moveName) => {
    const attackerData = attackerType === 'pokemon1' ? pokemon1Data : pokemon2Data;
    const defenderData = attackerType === 'pokemon1' ? pokemon2Data : pokemon1Data;
    const setDefenderHealth = attackerType === 'pokemon1' ? setHp2 : setHp1;

    if (attackerData && defenderData) {
      try {
        const moveResponse = await fetch(`https://pokeapi.co/api/v2/move/${moveName}`);
        const moveData = await moveResponse.json();

        if (Math.random() * 100 < moveData.accuracy) {
          let power = moveData.power;
          let damage = ((((2 * 20 / 5 + 2) * (attackerData.stats[1].base_stat) * power / attackerData.stats[2].base_stat) / 50) + 2);

          const defenderType = defenderData.types[0].type.name;
          const moveType = moveData.type.name;

          function isSuperEffective(moveType, defenderType) {
            const effectiveness = typeChart[moveType]?.[defenderType] || 1;
            return effectiveness > 1;
          }

          if (isSuperEffective(moveType, defenderType)) {
            damage *= 1.6;
          } else {
            damage *= 0.625;
          }

          damage = Math.floor(damage);
          setDefenderHealth(prevHp => Math.max(0, prevHp - damage));

          setCalculationText(`${attackerData.forms[0].name.toUpperCase()} used ${moveName} and did ${damage} damage`);
        }
        if (hp1<=0){
          setTurnCounterText(`${attackerData.forms[1].name.toUpperCase()} wins against ${defenderData.forms[1].name.toUpperCase()}`);
        }
        else if ( hp2 <=0 ){
          setTurnCounterText(`${attackerData.forms[0].name.toUpperCase()} wins against ${defenderData.forms[0].name.toUpperCase()}`);
          
        }
      } catch (error) {
        console.error(`Error handling attack with ${moveName}:`, error);
      }
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <div className="turncounter">
          <p>{turnCounterText || 'Play in turns till I fix the code'}</p>
        </div>
        <div className="dex dex1">
          <div className="droppoke wide">
            <select value={selectedPokemon1} onChange={(e) => handlePokemonChange('pokemon1', e)}>
              <option value="">Select Pokemon 1</option>
              {pokemonOptions.map(option => (
                <option key={option.value} value={option.value}>
                  {option.name}
                </option>
              ))}
            </select>
          </div>
          <div className="name wide">
            <h3 className="infoname">{pokemon1Data ? pokemon1Data.forms[0].name.toUpperCase() : ''}</h3>
            <div className="pokeimg">
              {pokemon1Data && <img src={pokemon1Data.sprites.front_default} alt="Pokemon 1" />}
            </div>
          </div>
          <div className="hp wide">HP:
            <div className="healthbar" style={{ width: `${hp1}%` }}></div>
          </div>
          <div className="ability wide">
            <p>Ability :</p>
            <p className="infoability">
              {pokemon1Data ? `${pokemon1Data.abilities[0].ability.name}` : 'nothing'}
            </p>
          </div>
          <div className="moves wide">
            {pokemon1Data && pokemon1Data.moves.slice(0, 4).map((move, index) => (
              <button
              key={move.move.name}
              className='move1'  // Add a CSS class based on the toggle state
              onClick={() => {
                handleAttack('pokemon1', move.move.name);
                handleChange();
              }}
              disabled={isToggled && !isToggled2}
            >
              {move.move.name}
            </button>
            ))}
          </div>
        </div>
        <div className="calculation">
          <p>{calculationText}</p>
        </div>
        <div className="dex dex2">
          <div className="droppoke wide">
            <select className="select2" value={selectedPokemon2} onChange={(e) => handlePokemonChange('pokemon2', e)}>
              <option value="">Select Pokemon 2</option>
              {pokemonOptions.map(option => (
                <option key={option.value} value={option.value}>
                  {option.name}
                </option>
              ))}
            </select>
          </div>
          <div className="name wide">
            <h3 className="infoname2">{pokemon2Data ? pokemon2Data.forms[0].name.toUpperCase() : ''}</h3>
            <div className="pokeimg2">
              {pokemon2Data && <img src={pokemon2Data.sprites.back_default} alt="Pokemon 2" />}
            </div>
          </div>
          <div className="hp wide">HP:
            <div className="healthbar2" style={{ width: `${hp2}%` }}></div>
          </div>
          <div className="ability wide">
            <p>Ability :</p>
            <p className="infoability2">
              {pokemon2Data ? `${pokemon2Data.abilities[0].ability.name}` : 'nothing'}
            </p>
          </div>
          <div className="moves wide">
            {pokemon2Data && pokemon2Data.moves.slice(0, 4).map((move, index) => ( 
              <button
              key={move.move.name}
              className='move1 movie2 ' // Add a CSS class based on the toggle state
              onClick={() => {
                handleAttack('pokemon2', move.move.name);
                handleChange();
              }}
              disabled={isToggled2 && !isToggled}
            >
              {move.move.name}
              </button>
            ))}
          </div>
        </div>
      </header>
    </div>
  );
}

export default App;
