import './index.css'

function App() {
  return (
    <><div className='division-one'>
        <header>
          <div className='intro'>
            <h1>Jonathan Eng</h1>
            <img src="src/images/Clear headshot.JPG" alt="Profile Picture" class="circular-image"></img>
          </div>
          <ul className='contact-info'>
            <li>Nanuet, NY</li>
            <li>jochengi77@gmail.com</li>
            <li>(845) 630-9051</li>
            <li>
              <a href="https://www.linkedin.com/in/jonathanheng77" target="_blank" rel="noopener noreferrer">
                <i className="fa-brands fa-linkedin padding" style={{ fontSize: '48px', color: '#0077b5' }}></i>
              </a>
            </li>
            <li>
              <a href="https://github.com/Jochengi" target="_blank" rel="noopener noreferrer">
                <i className="fa-brands fa-github padding" style={{ fontSize: '48px', color: 'gray' }}></i>
              </a>
            </li>
          </ul>
        </header>
      </div>
      <div className='division-two'>
        <h2>Education</h2>
        <div className='education'>
          <div className='school'>
            <div><strong>Columbia University</strong>, New York, NY</div>
            <div>September 2022 - May 2024</div>
          </div>
          <div className='degree'><em>Bachelor of Science in Computer Engineering</em></div>
        </div>
        <div className='education'>
          <div className='school'>
            <div><strong>Bard College/Conservatory of Music</strong>, Annandale-on-Hudson, NY</div>
            <div>September 2018 - May 2024</div>
          </div>
          <div className='degree'><em>Bachelor of Science in Computer Mathematics</em></div>
          <div className='degree'><em>Bachelor of Music in Computer Viola Performance</em></div>
        </div>
        <div className='education'>
          <div className='school'>
            <div><strong>Google Cybersecurity Professional Certificate</strong> - Coursera</div>
            <div>January 2024</div>
          </div>
          <div className='degree'><em>Credential URL: https://coursera.org/verify/professional-cert/KWHLGSLN8PNR</em></div>
        </div>
      </div>
      <div className='division-three'>
        <h2>Work Experience</h2>
        <div className='work'>
          <div className='school'>
            <div><strong>Systems Engineer - Spectrum News NY1</strong>, New York, NY</div>
            <div>December 2024 - Present</div>
          </div>
          <ul className='highlights'>
            <li>Pioneered Python scripts that automatically generate and deliver emails for MFA setup. Dynamically generates HTML
              content and leverages the Google Authenticator API to produce QR codes. Constantly updated code to meet new security
              requirements, such as allowing a new email address domain. Now deployed regionally.</li>
            <li>Developed a Batch script-based service that integrates with Windows Task Scheduler to schedule Windows updates for user
              workstations and automate update failure recovery mechanisms.</li>
            <li>Managed user accounts and provided technical support, ensuring operational continuity and security compliance.</li>
          </ul>
          <div className='school'>
            <div><strong>Independent Contractor - Outlier, AI</strong>, Remote</div>
            <div>December 2024 - Present</div>
          </div>
          <ul className='highlights'>
            <li>Evaluated AI-generated responses, performed validation and testing, and identified prompt failures to improve model
              performance.</li>
            <li>Developed Python and LaTeX prompts for AI training and validation.</li>
          </ul>
        </div>
      </div>
      <div className='division-two'>
        <h2 className='project-header'>Project Experience</h2>
        <div className='work'>
          <div className='school'>
            <div><strong><a href="https://jochengi.github.io/Personal-Website/">Personal Website</a></strong>, <em>Independent Project</em> - JavaScript, HTML, CSS</div>
          </div>
          <ul className='highlights'>
            <li>Designed and developed a responsive portfolio website using HTML5, CSS3, and JavaScript</li>
            <li>Developed an interactive Blackjack game</li>
          </ul>
          <div className='school'>
            <div><strong>Roblox Fried Finder</strong>, <em>Group Project</em> - Python, HTML, PostgreSQL</div>
          </div>
          <ul className='highlights'>
            <li>Developed a database-backed web application using Python, HTML, PostgreSQL, and SQL</li>
            <li>Designed SQL queries and implemented authentication tokens while protecting against SQL injection attacks</li>
          </ul>
          <div className='school'>
            <div><strong>Sudoku Solver</strong>, <em>Independent Project</em> - Python</div>
          </div>
          <ul className='highlights'>
            <li>Solves any Sudoku puzzle by inputting the starting board as a string of numbers, with 0 for blank tiles</li>
            <li>Incorporates backtracking algorithm with minimum remaining value heuristic and forward checking</li>
          </ul>
          <div className='school'>
            <div><strong>Common words Finder</strong>, <em>Independent Project</em> - Java</div>
          </div>
          <ul className='highlights'>
            <li>Implemented and compared Binary Search Tree, A VL Tree, and Hash Map data structures for word-frequency analysis</li>
            <li>Processed over 13,000 unique words to evaluate the performance of multiple data structure implementations</li>
          </ul>
        </div>
      </div>
      <div className='division-three'>
        <h2>Technical Skills</h2>
        <div className='work skills'>
          <div><strong>Languages:</strong> Python, Java, C/C++, JavaScript, HTML/CSS, SQL, Bash</div>
          <div><strong>Technologies:</strong> PostgreSQL, Linux, Git, Google Cloud Platform</div>
          <div><strong>Skills:</strong> Software Development, Object-Oriented Programming, Data Structures, Algorithms, Automation, Web Development, Systems
            Administration, Troubleshooting</div>
        </div>
      </div>
      <div className='footer'>Copyright @ Jochengi 2026</div>
    </>
  )
}

export default App