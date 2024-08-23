import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import hudson.util.Secret
import java.util.Properties
 
def props = new Properties()
def envFile = new File('/etc/jenkins.env')
if (envFile.exists()) {
    props.load(envFile.newDataInputStream())
} else {
    throw new RuntimeException("/etc/jenkins.env file not found")
}
 
// Parameters
def githubUsername = props.getProperty('GH_USERNAME')
def githubPassword = props.getProperty('GH_CREDS')
 
// Get the Jenkins instance
def jenkinsInstance = Jenkins.getInstance()
 
// Define the domain (GLOBAL)
def domain = Domain.global()

// get credentials store
def store = jenkinsInstance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
 
// Create GitHub credentials
def githubCredentials = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "github_token",
    "Github token for Jenkins",
    githubUsername,
    githubPassword
)
 
// add credential to store
store.addCredentials(domain, githubCredentials)

// save to disk
jenkinsInstance.save()

println "GitHub credentials added successfully with ID: github_token"