import './index.css'
import profilePic from './images/Clear headshot.jpg';
import { useState, useEffect } from 'react';

function App() {
  const [count, setCount] = useState("...");
  useEffect(() => {
    fetch("https://wv5p1vzt14.execute-api.us-east-1.amazonaws.com/views")
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: $(response.status)`);
        }
        return response.json();
      })
      .then(data => {
        setCount(data.count);
      })
      .catch(error => {
        console.error("Error updatig telemetry count:", error);
        setCount("Error");
      })
  }, []); // [] is the dependency array, which is needed to ensure useEffect only runs once

  return (
    <><div className='division-one'>
        <header>
          <div className='intro'>
            <h1>Jonathan Eng</h1>
            <img src={profilePic} alt="Profile Picture" class="circular-image"></img>
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
      <div className='division-two education-fix'>
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
          <div className='degree'><em>Bachelor of Arts in Mathematics</em></div>
          <div className='degree'><em>Bachelor of Music in Viola Performance</em></div>
        </div>
        <div className='education'>
          <div className='school'>
            <div><strong>Google Cybersecurity Professional Certificate</strong> - Coursera</div>
            <div>January 2024</div>
          </div>
          <div className='degree'><em>Credential URL: https://coursera.org/verify/professional-cert/KWHLGSLN8PNR</em></div>
        </div>
      </div>
      <div className='division-three experience'>
        <h2>Work Experience</h2>
        <div className='work'>
          <div className='school'>
            <div><strong>Systems Engineer - Spectrum News NY1</strong>, New York, NY</div>
            <div>December 2024 - Present</div>
          </div>
          <ul className='highlights'>
            <li>Pioneered Python scripts that automatically generate and deliver emails for MFA setup. Dynamically generated HTML
              content and leveraged the Google Authenticator API to produce QR codes. Constantly updated code to meet new security
              requirements, such as allowing a new email address domain. Now deployed regionally.</li>
            <li>Developed a Batch script-based service that integrates with Windows Task Scheduler to schedule Windows updates for user
              workstations and automate update failure recovery mechanisms.</li>
            <li>Managed user accounts and provided technical support, ensuring operational continuity and security compliance.</li>
          </ul>
          <div className='school'>
            <div><strong>Independent Contractor - Outlier AI</strong>, Remote</div>
            <div>May 2024 - December 2024</div>
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
            <div><strong>Cloud Resume Challenge (In Progress)</strong>, <em>Independent Project</em> - JavaScript, HTML, CSS</div>
          </div>
          <ul className='highlights'>
            <li>Deployed a highly available static resume website using AWS S3 and CloudFront, configuring AWS Route 53 for custom domain management and DNS routing via Terraform</li>
            <li>Developed a responsive single-page user interface using React, utilizing Vite for efficient asset bundling and instant hot module replacement (HMR)</li>
            <li>Architecting a serverless backend to track visitor metrics, utilizing Terraform to provision a DynamoDB table and Lambda functions</li>
          </ul>
          <div className='school'>
            <div><strong>Roblox Friend Finder</strong>, <em>Group Project</em> - Python, HTML, PostgreSQL</div>
          </div>
          <ul className='highlights'>
            <li>Developed a mock Roblox database-backed web application</li>
            <li>Designed SQL queries and implemented authentication tokens while protecting against SQL injection attacks</li>
          </ul>
          <div className='school'>
            <div><strong>Sudoku Solver</strong>, <em>Independent Project</em> - Python</div>
          </div>
          <ul className='highlights'>
            <li>Solves any Sudoku puzzle by inputting the starting board as a string of numbers, with 0 for blank tiles</li>
            <li>Incorporates a backtracking algorithm with the minimum remaining value heuristic and forward checking</li>
          </ul>
        </div>
      </div>
      <div className='division-three'>
        <h2>Technical Skills</h2>
        <div className='work skills'>
          <div><strong>Languages:</strong> Python, HTML/CSS, JavaScript, SQL, Java, C/C++, Bash</div>
          <div><strong>Technologies:</strong> React, Vite, Terraform, AWS, PostgreSQL, Linux, Git, Google Cloud Platform (GCP)</div>
          <div><strong>Skills:</strong> Software Development, Automation, Web Development, Infrastructure as Code (IaC), Object-Oriented Programming, Data 
            Structures, Algorithms, Systems Administration, Troubleshooting</div>
        </div>
      </div>
      <div className='footer'>@ 2026 Jonathan Eng | Page Views: {count}</div>
    </>
  )
}

export default App