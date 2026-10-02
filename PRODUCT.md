# PokeMoodle: product vision

A gamified, customised Moodle themed on the original 151 Pokémon, in look and feel and in how learning activities work, modelled on the turn-based battles of Pokémon Gold and Silver. Built from ten years of Moodle experience.

## Principles
- **New plugins first, core untouched.** Everything lives in new plugins (theme, local, block, mod) so Moodle upgrades stay cheap. Core changes are allowed only when a plugin API genuinely cannot do the job, and each one is recorded and justified.
- **Learning stays the point.** Game mechanics reward and reinforce learning; they never replace assessment integrity.
- **Opt-in and safe.** Every feature is behind an admin or course switch, off until tested. Data about students follows Moodle's privacy rules.
- **Accessible.** Reduced-motion mode, sound off by default, keyboard play, readable contrast.

## Idea map (Gold/Silver to Moodle)
| Game idea | Moodle idea |
|---|---|
| Regions, routes, towns | Courses, topics, learning paths |
| Wild and trainer battles | Quiz-style battles using the question bank (a correct answer is a hit, a wrong one lets the opponent hit back) |
| Moves and types | Question categories and tags, subject strengths and weaknesses |
| Gym badges, Elite Four | Moodle badges, course completion, final assessments |
| XP, levels, evolution | Points, level-ups, milestones |
| Party of six, PC box, Pokédex | Trainer profile, collection of the original 151, dashboard blocks |
| Items, Pokémon Center | Hints and power-ups; revision and "heal" sessions |
| Day and night | Time-aware theme |

## Planned plugin shape (to be confirmed in T-018)
- `theme_pokemoodle`: look and feel, child of Boost.
- `local_pokemoodle`: game engine (trainer, XP, collection, events, privacy provider).
- `mod_pokebattle`: the battle activity, using the question bank.
- `block_pokedex`, `block_trainercard`: dashboard blocks.
- Reports and teacher tools as small separate plugins.

## Open risk
Pokémon names, sprites, audio and logos are trademarked and copyrighted. See T-029 and D-08 before any artwork is added.
