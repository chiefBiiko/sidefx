// TODO: implement sound in a hyperportable way! how???
function initializeChainzGame() {
  'use strict'
  const body = document.querySelector('body')
  var interval_id // interval reference
  // std helpers
  function randomArrayPick(array) {
    return array[Math.floor(Math.random() * array.length)]
  }
  function randomIntegerInRange(min, max) { // min and max are inclusive
    const minceil = Math.ceil(min)
    const maxflo = Math.floor(max)
    return Math.floor(Math.random() * (maxflo - minceil + 1) + minceil)
  }
  // helper called in interval to manage animation of all chainz
  function updateChainz() {
    const chainz = Array.from(document.getElementsByClassName('_chainz-chain'))
    if (chainz.length !== 0) {
      chainz.forEach(chain => {
        // setting y position
        chain._top += chain._speed
        chain.style.top = `${chain._top}px`
        // alternating rotation direction
        Math.abs(chain._rotationAngle) >= 25 ?
          chain._rotationDirection *= -1 : chain._rotationDirection
        chain._rotationAngle += chain._speed * chain._rotationDirection
        // chain swanging
        chain.style.transform = `rotate(${chain._rotationAngle}deg)`
         // toss once out of bounds
        if (chain._top > window.innerHeight) {
          chain.parentNode.removeChild(chain)
        }
      })
    } else { // render new chainz
      const num_chainz = randomIntegerInRange(1, 5)
      for (let i = 0; i < num_chainz; i++) {
        const edge = randomIntegerInRange(20, 50)
        const worth = randomIntegerInRange(edge / 2, edge * 2)
        body.appendChild(makeChain(edge, edge, worth))
      }
    }
  }
  // helper that destroys and kills all chainz
  function destroyChainz() {
    const chainz = Array.from(document.getElementsByClassName('_chainz-chain'))
    chainz.forEach(chain => chain.parentNode.removeChild(chain))
  }
  // chain factory
  function makeChain(width=25, height=25, worth=10) {
    const chain = document.createElement('div')
    chain.className = '_chainz-chain'
    chain._worth = worth
    chain._speed = randomIntegerInRange(1, 2)
    chain._rotationAngle = 0
    chain._rotationDirection = 1
    // chain styling
    chain.style.zIndex = 9999
    chain.style.backgroundColor = '#FFD000'
    chain.style.cursor = 'pointer'
    chain.style.width = `${width}px`
    chain.style.height = `${height}px`
    // positioning - set a quasi-random position within the viewport
    chain.style.position = 'fixed'
    chain.style.top = `${randomIntegerInRange(-height, 0)}px`
    chain.style.left =
      `${randomIntegerInRange(0, window.innerWidth - width)}px`
    // setting numeric position attributes for less parsing in interval
    chain._top = parseInt(chain.style.top)
    // register a click handler for the new element
    chain.onclick = function(e) { // this === chain
      const score = document.querySelector('#_chainz-score')
      body.appendChild(makeHitBubble(this._worth, this.style.top,
                                     this.style.left))
      score._score += this._worth
      score.innerText = `${score._score}`
      this.parentNode.removeChild(this)
    }
    // factory return
    return chain
  }
  // hit bubble factory
  function makeHitBubble(worth, top, left) {
    const bubble = document.createElement('span')
    // bubble ...styling
    bubble.innerText = `${worth}$€`
    bubble.style.zIndex = 10000
    bubble.style.position = 'fixed'
    bubble.style.left = left
    bubble.style.top = top
    window.setTimeout(() => bubble.parentNode.removeChild(bubble), 1000)
    // factory return
    return bubble
  }
  // controls factory
  function makeControls() {
    const container = document.createElement('div')
    const toggler = document.createElement('div') // playback toggler
    const scoreboard = document.createElement('span')
    const score = document.createElement('span')
    // container styling
    container.style.zIndex = 10000
    container.style.position = 'fixed'
    container.style.right = '10px'
    container.style.top = '10px'
    container.style.display = toggler.style.display = ' inline-block'
    container.style.textAlign = 'center'
    // toggler styling
    toggler.innerText = 'play!'
    toggler.style.cursor = 'pointer'
    toggler.style.marginBottom = '10px'
    // scoreboard and score ...styling
    scoreboard.innerText = '©@$h:'
    score.id = '_chainz-score'
    score.innerText = '0'
    score._score = 0
    // a little logic
    toggler.playing = false
    toggler.onclick = function() { // this === toggler
      if (this.playing) { // stop and kill all chainz
        window.clearInterval(interval_id)
        destroyChainz()
        this.playing = false
        this.innerText = 'play!'
      } else {
        const num_chainz = randomIntegerInRange(1, 5)
        for (let i = 0; i < num_chainz; i++) {
          const edge = randomIntegerInRange(20, 50)
          const worth = randomIntegerInRange(edge / 2, edge * 2)
          body.appendChild(makeChain(edge, edge, worth))
        }
        interval_id = window.setInterval(updateChainz, 50)
        this.playing = true
        this.innerText = 'quit!'
      }
    }
    // assembling controls
    scoreboard.appendChild(document.createElement('br'))
    scoreboard.appendChild(score)
    container.appendChild(toggler)
    container.appendChild(document.createElement('br'))
    container.appendChild(scoreboard)
    // factory return
    return container
  }
  body.appendChild(makeControls())
}
