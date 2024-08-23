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
def dockerhubUsername = props.getProperty('DOCKERHUB_USERNAME')
def dockerhubPassword = props.getProperty('DOCKERHUB_CREDS')
 
// Get the Jenkins instance
def jenkinsInstance = Jenkins.getInstance()
 
// Define the domain (GLOBAL)
def domain = Domain.global()
 
// get credentials store
def store = jenkinsInstance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// Create DockerHub credentials
def dockerhubCredentials = new UsernamePasswordCredentialsImpl(
    CredentialsScope.GLOBAL,
    "dockerhub_credentials",
    "DockerHub token for Jenkins",
    dockerhubUsername,
    dockerhubPassword
)

// add credential to store
store.addCredentials(domain, dockerhubCredentials)

// save to disk
jenkinsInstance.save()

println "DockerHub credentials added successfully with ID: dockerhub_credentials"