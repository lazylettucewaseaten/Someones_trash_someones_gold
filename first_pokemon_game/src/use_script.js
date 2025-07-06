// Import necessary functions and constants
import { typeChart } from './pokedex';

// Helper functions
export function generateRandom(maxLimit = 100) {
  return Math.floor(Math.random() * maxLimit);
}

export function generateRandomtill4(maxLimit = 4) {
  return Math.floor(Math.random() * maxLimit);
}

export async function fetchPokemonData(pokemonName) {
  const BURL = "https://pokeapi.co/api/v2/pokemon";
  const response = await fetch(`${BURL}/${pokemonName.toLowerCase()}`);
  return response.json();
}

export async function fetchMoveData(moveName) {
  const AURL = "https://pokeapi.co/api/v2/move";
  const response = await fetch(`${AURL}/${moveName}`);
  return response.json();
}

export function updatePokemonInfo(data, imgElement, nameElement, abilityElement, moveElements, healthbarElement, dexElement) {
  const img = document.createElement("img");
  img.src = data.sprites.front_default;
  imgElement.innerHTML = ''; // Clear previous image
  imgElement.appendChild(img);

  nameElement.innerHTML = data.forms[0].name.toUpperCase();

  moveElements.forEach((element, index) => {
    const move = data.moves[index];
    element.innerHTML = move ? move.move.name : 'N/A';
  });

  abilityElement.innerHTML = `${data.abilities[0].ability.name}, ${data.abilities[1].ability.name}`;

  const typeColorMap = {
    normal: 'cornsilk',
    fire: 'orangered',
    water: 'cyan',
    electric: 'goldenrod',
    grass: 'green',
    ice: 'aqua',
    fighting: 'red',
    poison: 'violet',
    ground: 'yellow',
    flying: 'floralwhite',
    psychic: 'plum',
    bug: 'greenyellow',
    ghost: 'blue',
    dragon: 'blueviolet',
    dark: 'brown',
    steel: 'gainsboro',
    fairy: 'pink'
  };

  dexElement.style.backgroundColor = typeColorMap[data.types[0].type.name] || 'white';

  healthbarElement.style.width = `${(data.stats[0].base_stat) / 255 * 100}%`;
}

export function handleAttack(moveElement, attackerInfo, defenderInfo, attackerHealthbar, defenderHealthbar, attackerMoves, defenderMoves) {
  return async () => {
    const [attackerName, defenderName] = [attackerInfo.name, defenderInfo.name];

    const [attackerData, defenderData] = await Promise.all([
      fetchPokemonData(attackerName),
      fetchPokemonData(defenderName)
    ]);

    const moveData = await fetchMoveData(moveElement.innerHTML);

    if (generateRandom() < moveData.accuracy) {
      let power = moveData.power;
      let damage = ((((2 * 20 / 5 + 2) * (attackerData.stats[1].base_stat) * power / attackerData.stats[2].base_stat) / 50) + 2);

      const defenderType = defenderData.types[0].type.name;
      const moveType = moveData.type.name;

      function isSuperEffective(moveType, defenderType) {
        const effectiveness = typeChart[moveType]?.[defenderType] || 1;
        damage *= effectiveness;
        return effectiveness > 1;
      }

      if (isSuperEffective(moveType, defenderType)) {
        damage *= 1.6;
      } else {
        damage *= 0.625;
      }

      damage = Math.floor(damage);

      let newHP = Math.max(0, defenderData.stats[0].base_stat - damage);
      defenderHealthbar.style.width = `${(newHP) / 255 * 100}%`;

      // Update calculation display
      const resultText = `${attackerName} used ${moveElement.innerHTML} and did ${damage} damage`;
      document.querySelector(".calculation p").innerHTML = resultText;

      // Disable buttons after attack
      attackerMoves.forEach(button => button.disabled = true);
      defenderMoves.forEach(button => button.disabled = false);

      if (newHP <= 0) {
        attackerMoves.forEach(button => button.disabled = true);
        document.querySelector(".turncounter p").innerHTML = `${attackerName} wins against ${defenderName}`;
      }
    }
  };
}