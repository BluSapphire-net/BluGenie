'''
    .DESCRIPTION
        getpyprocesslist is a process meta data parser.  currently you can parse using regex based on the following properties
            o Name (Default)
            o Caption
            o CommandLine
            o Path
            o ProcessId
            o ProcessOwner
            o hashmd5
            o hashsha1
            o hashsha256
            o hashsha384
            o hashsha512

    .PARAMETER --help
        Description: Print this message and exit
        Notes:
        Alias: -h

	.PARAMETER --hash
        Description: Specifies the cryptographic hash value of the contents of the specified file.
        Notes: The hash property names ('sha1', 'sha256', 'sha384', 'sha512', 'md5')
        Alias: -hs

    .PARAMETER pattern=<str>
        Description: Search Pattern using RegEx
        Notes: The default RegEx pattern is (.*)
        Alias:

	.PARAMETER filtertype=<str>
        Description: Select which property table to parse using the property ID
        Notes:  Name = Query the (Name) value (Default)
                Caption = Query the (Caption) value
                CommandLine = Query the (CommandLine) value
                Path = Query the (Path) value
                ProcessId = Query the (ProcessId) value
                ProcessOwner = Query the (ProcessOwner) value
        Alias:

    .PARAMETER --outyaml
        Description: Output return data as YAML Format
        Notes:
        Alias: -oy

    .PARAMETER --outjson
        Description: Output return data as JSON Format (Default)
        Notes:
        Alias: -oj

    .PARAMETER --outstring
        Description: Output return data as a String
        Notes:
        Alias: -os

    .PARAMETER --outcsv
        Description: Output return data as a CSV
        Notes:
        Alias: -oc

    .PARAMETER --verbose
        Description: Verbose Output.  Display each parameter and set value
        Notes: Since stdout is updated with verbose data, the normal output cannot be
                piped cleanly to another command
        Alias: -v

    .PARAMETER --verboseonly
        Description: Only show the Verbose Output.  This will not run the command.
        Notes:
        Alias: -vo

    .EXAMPLE
        Command: python .\getpyprocesslist.py -h
        Description: Print the command help reference
        Notes:

	.EXAMPLE
        Command: python .\getpyprocesslist.py --hash
        Description: Fetch the process in the system along with the hashes of the process.
        Notes:

	.EXAMPLE
        Command: python .\getpyprocesslist.py --hash -v
        Description: Print the Parameter values and internal call command prior to running the Parse command
        Notes:

	.EXAMPLE
        Command: python .\getpyprocesslist.py --hash --verboseonly
        Description: Print the Verbose output only.  This will not run the Parse process
        Notes:

    .EXAMPLE
        Command: python .\getpyprocesslist.py -ft='Name' -pt='BluGenie'
        Description: Fetch the Process details based on filtertype and pattern, parse the process
        Notes:

    .EXAMPLE
        Command: python .\getpyprocesslist.py -ft='CommandLine' -pt='c:\\\\BG' -hs
        Description: Fetch the Process details based on FilterType and Pattern with the process Hashes.
        Notes:

    .NOTES

        • [Original Author]
            o  Dubey Ravi Vinod
        • [Original Build Version]
            o  21.07.0901 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [Python Compatibility]
            o  3.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  json -> reference https://docs.python.org/3/library/json.html
            o  regex -> reference https://pypi.org/project/regex/
            o  yaml -> reference https://pyyaml.org/wiki/PyYAMLDocumentation
            o  hashlib -> reference https://docs.python.org/3/library/hashlib.html
            o  sys -> reference https://docs.python.org/3/library/sys.html
            o  psutil -> reference https://psutil.readthedocs.io/en/latest/#
            o  wmi -> reference http://timgolden.me.uk/python/wmi/cookbook.html
		• [Build Notes]
            o  21.07.0901
				• [Dubey Ravi Vinod] Added support for CLI
                • [Dubey Ravi Vinod] Added support for JSON formatted return data
                • [Dubey Ravi Vinod] Added support for YAML formatted return data
                • [Dubey Ravi Vinod] Added support for String formatted return data
                • [Dubey Ravi Vinod] Added support for CSV formatted return data
                • [Dubey Ravi Vinod] Updated .Py file Help information
                • [Dubey Ravi Vinod] Updated get_processlist API Help information
                • [Dubey Ravi Vinod] Updated Hash chucks to use up less memory when parsing a file (1024)
                • [Dubey Ravi Vinod] Added a CLI help menu defining all the parameters
'''

#
#[Import Modules]
#
import json
import regex				#code reference https://pypi.org/project/regex/
import yaml                 #code reference https://pyyaml.org/wiki/PyYAMLDocumentation
import hashlib              #code reference https://docs.python.org/3/library/hashlib.html
import wmi                  #code reference http://timgolden.me.uk/python/wmi/cookbook.html
import sys                  #code reference https://docs.python.org/3/library/sys.html
import psutil               #code reference https://psutil.readthedocs.io/en/latest/#


def get_processlist(filtertype='Name', pattern='.*', hash=False):
    """
    .DESCRIPTION
        getpyprocesslist is a process meta data parser.  currently you can parse using regex based on the following properties
            o Name (Default)
            o Caption
            o CommandLine
            o Path
            o ProcessId
            o ProcessOwner
            o hashmd5
            o hashsha1
            o hashsha256
            o hashsha384
            o hashsha512

    .PARAMETER --help
        Description: Print this message and exit
        Notes:
        Alias: -h

	.PARAMETER --hash
        Description: Specifies the cryptographic hash value of the contents of the specified file.
        Notes: The hash property names ('sha1', 'sha256', 'sha384', 'sha512', 'md5')
        Alias: -hs

    .PARAMETER pattern=<str>
        Description: Search Pattern using RegEx
        Notes: The default RegEx pattern is (.*)
        Alias:

	.PARAMETER filtertype=<str>
        Description: Select which property table to parse using the property ID
        Notes:  Name = Query the (Name) value (Default)
                Caption = Query the (Caption) value
                CommandLine = Query the (CommandLine) value
                Path = Query the (Path) value
                ProcessId = Query the (ProcessId) value
                ProcessOwner = Query the (ProcessOwner) value
        Alias:

    .PARAMETER --outyaml
        Description: Output return data as YAML Format
        Notes:
        Alias: -oy

    .PARAMETER --outjson
        Description: Output return data as JSON Format (Default)
        Notes:
        Alias: -oj

    .PARAMETER --outstring
        Description: Output return data as a String
        Notes:
        Alias: -os

    .PARAMETER --outcsv
        Description: Output return data as a CSV
        Notes:
        Alias: -oc

    .PARAMETER --verbose
        Description: Verbose Output.  Display each parameter and set value
        Notes: Since stdout is updated with verbose data, the normal output cannot be
                piped cleanly to another command
        Alias: -v

    .PARAMETER --verboseonly
        Description: Only show the Verbose Output.  This will not run the command.
        Notes:
        Alias: -vo

    .EXAMPLE
        Command: python .\getpyprocesslist.py -h
        Description: Print the command help reference
        Notes:

	.EXAMPLE
        Command: python .\getpyprocesslist.py --hash
        Description: Fetch the process in the system along with the hashes of the process.
        Notes:

	.EXAMPLE
        Command: python .\getpyprocesslist.py --hash -v
        Description: Print the Parameter values and internal call command prior to running the Parse command
        Notes:

	.EXAMPLE
        Command: python .\getpyprocesslist.py --hash --verboseonly
        Description: Print the Verbose output only.  This will not run the Parse process
        Notes:

    .EXAMPLE
        Command: python .\getpyprocesslist.py -ft='Name' -pt='BluGenie'
        Description: Fetch the Process details based on filtertype and pattern, parse the process
        Notes:

    .EXAMPLE
        Command: python .\getpyprocesslist.py -ft='CommandLine' -pt='c:\\\\BG' -hs
        Description: Fetch the Process details based on FilterType and Pattern with the process Hashes.
        Notes:

    .NOTES

        • [Original Author]
            o  Dubey Ravi Vinod
        • [Original Build Version]
            o  21.07.0901 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [Python Compatibility]
            o  3.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  json -> reference https://docs.python.org/3/library/json.html
            o  regex -> reference https://pypi.org/project/regex/
            o  yaml -> reference https://pyyaml.org/wiki/PyYAMLDocumentation
            o  hashlib -> reference https://docs.python.org/3/library/hashlib.html
            o  sys -> reference https://docs.python.org/3/library/sys.html
            o  psutil -> reference https://psutil.readthedocs.io/en/latest/#
            o  wmi -> reference http://timgolden.me.uk/python/wmi/cookbook.html
		• [Build Notes]
            o  21.07.0901
				• [Dubey Ravi Vinod] Added support for CLI
                • [Dubey Ravi Vinod] Added support for JSON formatted return data
                • [Dubey Ravi Vinod] Added support for YAML formatted return data
                • [Dubey Ravi Vinod] Added support for String formatted return data
                • [Dubey Ravi Vinod] Added support for CSV formatted return data
                • [Dubey Ravi Vinod] Updated .Py file Help information
                • [Dubey Ravi Vinod] Updated get_processlist API Help information
                • [Dubey Ravi Vinod] Updated Hash chucks to use up less memory when parsing a file (1024)
                • [Dubey Ravi Vinod] Added a CLI help menu defining all the parameters
    """
    wmi_process = wmi.WMI() # Calling the WMI class.
    processes = [] # Empty list

    class fileobject:
        def __init__(self):
            self.name = ''
            self.caption = ''
            self.commandline = ''
            self.processid = ''
            self.sessionid = ''
            self.path = ''
            self.parentprocessid = ''
            self.parentprocessname = ''
            self.parentprocesspath = ''
            self.owner = ''
            self.hashsha1 = ''
            self.hashsha256 = ''
            self.hashsha384 = ''
            self.hashsha512 = ''
            self.hashmd5 = ''
            self.signature_comment = ''
            self.signature_fileversion = ''
            self.signature_description = ''
            self.signature_date = ''
            self.signature_company = ''
            self.signature_publisher = ''
            self.signature_verified = ''

        def __str__(self):
                for key,value in self.__dict__.items():
                    print('{} = {}'.format(key,value))

        def __repr__(self):
            reprstring = '<__main__.fileobject: '
            reprcount = self.__dict__.items().__len__()
            reprcounter = 0
            for key,value in self.__dict__.items():
                    reprstring = reprstring + (' {} = "{}"'.format(key,value))
                    reprcounter += 1
                    if reprcounter < reprcount:
                        reprstring = reprstring + ';'
            reprstring = reprstring + '>'
            return reprstring

    def hashvalue(path):
        '''
        Process Hash Value

        :param path: path to folder or directory [Note: if using a string make sure to use r'' to set the string as RAW]
        :return: ** Values **
                sha1,
                sha256,
                sha384,
                sha512,
                md5
        '''

        class hashes():
            def __init__(self):
                self.hashsha1 = ''
                self.hashsha256 = ''
                self.hashsha384 = ''
                self.hashsha512 = ''
                self.hashmd5 = ''

            def __str__(self):
                for key,value in self.__dict__.items():
                    print('{} = {}'.format(key,value))
                return

        file_hashsha1   = hashlib.sha1()
        file_hashsha256 = hashlib.sha256()
        file_hashsha384 = hashlib.sha384()
        file_hashsha512 = hashlib.sha512()
        file_hashmd5    = hashlib.md5()

        with open(path,'rb') as file:
            # loop till the end of the file
            chunk = 0
            while chunk != b'':
                # read only 1024 bytes at a time
                chunk = file.read(1024)
                file_hashsha1.update(chunk)
                file_hashsha256.update(chunk)
                file_hashsha384.update(chunk)
                file_hashsha512.update(chunk)
                file_hashmd5.update(chunk)

        h = hashes()
        h.hashsha1 = file_hashsha1.hexdigest()
        h.hashsha256 = file_hashsha256.hexdigest()
        h.hashsha384 = file_hashsha384.hexdigest()
        h.hashsha512 = file_hashsha512.hexdigest()
        h.hashmd5 = file_hashmd5.hexdigest()

        return(h)

    def getting_owner(GetOwner):
        '''
        Process Owner

        :param GetOwner: owner of the process
        :return: ** Values **
                owner
        '''
        owner = ''
        try:
            if ((GetOwner()[0] == None) and (GetOwner()[2] == None)):
                owner = ''
            else:
                owner = GetOwner()[0] + "\\" + GetOwner()[2]
                # print(owner)
            return owner
        except Exception as e:
            pass

    def get_parent_process_name(parentprocessid):
        '''
        Process Parent Process Name

        :param ParentProcessId: parent process id of the running process
        :return: ** Values **
                parent_process_name
        '''
        try:
            parent_process_name = psutil.Process(parentprocessid).parent().as_dict(attrs=['name'])
            # print(parent_process_name['name'])
            return parent_process_name['name']
        except Exception as e:
            return ''

    def get_parent_process_path(parentprocessid):
        '''
        Process Parent Process Path

        :param ParentProcessId: parent process id of the running process
        :return: ** Values **
                parent_process_path
        '''
        try:
            parent_process = psutil.Process(parentprocessid).parent().as_dict(attrs=['pid', 'name', 'status'])
            parent_process_path = psutil.Process(parent_process['pid']).cmdline()
            # print(parent_process_path[0])
            return parent_process_path[0]
        except Exception as e:
            return ''

    def get_hashes(ProcessPath):
        try:
            # print("Enter into Hash Condition")
            h = hashvalue(ProcessPath)
            process_.hashsha1 = h.hashsha1
            process_.hashsha256 = h.hashsha256
            process_.hashsha384 = h.hashsha384
            process_.hashsha512 = h.hashsha512
            process_.hashmd5 = h.hashmd5
            processes.append(process_)
        except:
            # process_.hash = sys.last_value.__str__()
            pass

    #regionmain
    for process in wmi_process.Win32_Process():
        process_ = fileobject()
        process_.name = process.Name
        process_.caption = process.Caption
        process_.commandline = str(process.CommandLine).replace('\\\\', '\\').replace('"', '')
        process_.processid = process.ProcessId
        process_.sessionid = process.SessionId
        process_.path = process.ExecutablePath
        process_.parentprocessid = process.ParentProcessId
        process_.parentprocessname = get_parent_process_name(process_.parentprocessid)
        process_.parentprocesspath = get_parent_process_path(process_.parentprocessid)
        process_.owner = getting_owner(process.GetOwner)

        if filtertype == 'Name':
            if regex.findall(pattern, process_.name, 2):
                if hash ==True:
                    process_hash = get_hashes(process_.path)
                else:
                    processes.append(process_)
        if filtertype == 'Caption':
            if regex.findall(pattern, process_.caption, 2):
                if hash ==True:
                    process_hash = get_hashes(process_.path)
                else:
                    processes.append(process_)
        if filtertype == 'CommandLine':
            if regex.findall(pattern, process_.commandline, 2):
                if hash ==True:
                    process_hash = get_hashes(process_.path)
                else:
                    processes.append(process_)
        if filtertype == 'Path':
            if regex.findall(pattern, process_.path, 2):
                if hash ==True:
                    process_hash = get_hashes(process_.path)
                else:
                    processes.append(process_)
        if filtertype == 'ProcessId':
            if regex.findall(pattern, process_.processid, 2):
                if hash ==True:
                    process_hash = get_hashes(process_.path)
                else:
                    processes.append(process_)
        if filtertype == 'ProcessOwner':
            if regex.findall(pattern, process_.owner, 2):
                if hash ==True:
                    process_hash = get_hashes(process_.path)
                else:
                    processes.append(process_)

        del process_

    return processes
    #endregionmain


def ModHelp():
    "This displays the current Help information for this Module"
    myhelp = '''
Usage:
  getpyprocesslist <options>

Options:
  -h,           --help             : Print this message and exit
  -pt=<str>,    --pattern=<str>    : Search Pattern using RegEx
                                       o Note:  The default RegEx pattern is (.*) which is all files
  -ft=<int>,    --filtertype=<int> : Select which property table to parse using the pattern value
                                       0 = Query the (fullname) value (Default)
                                       1 = Query the (hashmd5) value
                                       2 = Query the (hashsha1) value
                                       3 = Query the (hashsha256) value
                                       4 = Query the (hashsha384) value
                                       5 = Query the (hashsha512) value
  -hs,          --hash             : Specifies the cryptographic hash value of the contents of the specified file.
                                       o The hash property names ('sha1', 'sha256', 'sha384', 'sha512', 'md5')
  -oy,          --outyaml          : Output return data as YAML Format
  -oj,          --outjson          : Output return data as JSON Format (Default)
  -os,          --outstring        : Output return data as a String
  -oc,          --outcsv           : Output return data as a CSV
  -v,           --verbose          : Verbose Output.  Display each parameter and set value
  -vo,          --verboseonly      : Only show the Verbose Output.  This will not run the command.

Examples:
  - python .\getpyprocesslist.py -h
  - python .\getpyprocesslist.py --hash -oy
  - python .\getpyprocesslist.py --hash -v
  - python .\getpyprocesslist.py --hash --verboseonly
  - python .\getpyprocesslist.py -ft='Name' -pt='BluGenie'
  - python .\getpyprocesslist.py -ft='CommandLine' -pt='c:\\\\BG' -hs
  - python .\getpyprocesslist.py -pt"\.exe$|\.bat$" -h
    '''
    print(myhelp)

commandline = ' '.join(sys.argv[1:])

#region
if regex.match('-h$|--help$', commandline, 2):
    ModHelp()
elif commandline != '':
    clipattern = '.*'
    clihash = False
    clifiltertype = 'Name'
    clioutyaml = False
    clioutjson = False
    clioutstring = False
    cliverbose = False
    cliverboseonly = False
    clioutcsv = False

    for arg in sys.argv:
        if regex.match('-pt=|--pattern=', arg, 2):
            clipattern = arg.replace('-pt=','').replace('--pattern=','').strip()
        elif regex.match('-hs$|--hash$', arg, 2):
            clihash = True
        elif regex.match('-ft=|--filtertype=', arg, 2):
            clifiltertype = arg.replace('-ft=','').replace('--filtertype=','').strip()
        elif regex.match('-oy$|--outyaml$', arg, 2):
            clioutyaml =True
            clioutjson = False
            clioutstring = False
            clioutcsv = False
        elif regex.match('-oj$|--outjson$', arg, 2):
            clioutyaml =False
            clioutjson = True
            clioutstring = False
            clioutcsv = False
        elif regex.match('-os$|--outstring$', arg, 2):
            clioutyaml =False
            clioutjson = False
            clioutstring = True
            clioutcsv = False
        elif regex.match('-oc$|--outcsv', arg, 2):
            clioutyaml =False
            clioutjson = False
            clioutstring = False
            clioutcsv = True
        elif regex.match('-v$|--verbose$', arg, 2):
            cliverbose = True
        elif regex.match('-vo$|--verboseonly$', arg, 2):
            cliverboseonly = True

    if cliverbose == True or cliverboseonly == True:
        print('')
        print('Verbose Information:')
        print('  Parameter Values:')
        print(f'    pattern = {clipattern}')
        print(f'    hash = {clihash}')
        print(f'    filtertype = {clifiltertype}')
        print(f'    outyaml = {clioutyaml}')
        print(f'    outjson = {clioutjson}')
        print(f'    outstring = {clioutstring}')
        print(f'    outcsv = {clioutcsv}')
        print(f'    verbose = {cliverbose}')
        print(f'    verboseonly = {cliverboseonly}')
        print('')
        print('  Function Call:')
        print(f'    get_childitemlist(filtertype="{clifiltertype}, "pattern="{clipattern}", hash="{clihash}")')
        print('')

    if cliverboseonly == False:
        result = get_processlist(pattern=clipattern, filtertype=clifiltertype, hash=clihash)

        if clioutstring == True:
            for item in result:
                print('name="{}"\ncaption="{}"\ncommandline="{}"\nprocessid="{}"\nsessionid="{}"\npath="{}"\nparentprocessid="{}"\nparentprocessname="{}"\nparentprocesspath="{}"\nowner="{}"\nhashsha1="{}"\nhashsha256="{}"\nhashsha384="{}"\nhashsha512="{}"\nhashmd5="{}"\nsignature_comment="{}"\nsignature_fileversion="{}"\nsignature_description="{}"\nsignature_date="{}"\nsignature_company="{}"\nsignature_publisher="{}"\nsignature_verified="{}"\n'.format(item.__dict__.__getitem__('name').__str__(), item.__dict__.__getitem__('caption').__str__(), item.__dict__.__getitem__('commandline').__str__().replace("\\\\","\\"), item.__dict__.__getitem__('processid').__str__(), item.__dict__.__getitem__('sessionid').__str__(), item.__dict__.__getitem__('path').__str__().replace("\\\\","\\"), item.__dict__.__getitem__('parentprocessid').__str__(), item.__dict__.__getitem__('parentprocessname').__str__(), item.__dict__.__getitem__('parentprocesspath').__str__().replace("\\\\", "\\"), item.__dict__.__getitem__('owner').__str__(), item.__dict__.__getitem__('hashsha1').__str__(), item.__dict__.__getitem__('hashsha256').__str__(), item.__dict__.__getitem__('hashsha384').__str__(), item.__dict__.__getitem__('hashsha512').__str__(), item.__dict__.__getitem__('hashmd5').__str__(), item.__dict__.__getitem__('signature_comment').__str__(), item.__dict__.__getitem__('signature_fileversion').__str__(), item.__dict__.__getitem__('signature_description').__str__(), item.__dict__.__getitem__('signature_date').__str__(), item.__dict__.__getitem__('signature_company').__str__(), item.__dict__.__getitem__('signature_publisher').__str__(), item.__dict__.__getitem__('signature_verified').__str__()))

        elif clioutcsv == True:
            print('"name", "caption", "commandline", "processid", "sessionid", "path", "parentprocessid", "parentprocessname", "parentprocesspath", "owner", "hashsha1", "hashsha256", "hashsha384", "hashsha512", "hashmd5", "signature_comment", "signature_fileversion", "signature_description", "signature_date", "signature_company", "signature_publisher", "signature_verified"')   
            for item in result:
                print('"{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}"'.format(item.__dict__.__getitem__('name').__str__(), item.__dict__.__getitem__('caption').__str__(), item.__dict__.__getitem__('commandline').__str__().replace("\\\\","\\"), item.__dict__.__getitem__('processid').__str__(), item.__dict__.__getitem__('sessionid').__str__(), item.__dict__.__getitem__('path').__str__().replace("\\\\","\\"), item.__dict__.__getitem__('parentprocessid').__str__(), item.__dict__.__getitem__('parentprocessname').__str__(), item.__dict__.__getitem__('parentprocesspath').__str__().replace("\\\\", "\\"), item.__dict__.__getitem__('owner').__str__(), item.__dict__.__getitem__('hashsha1').__str__(), item.__dict__.__getitem__('hashsha256').__str__(), item.__dict__.__getitem__('hashsha384').__str__(), item.__dict__.__getitem__('hashsha512').__str__(), item.__dict__.__getitem__('hashmd5').__str__(), item.__dict__.__getitem__('signature_comment').__str__(), item.__dict__.__getitem__('signature_fileversion').__str__(), item.__dict__.__getitem__('signature_description').__str__(), item.__dict__.__getitem__('signature_date').__str__(), item.__dict__.__getitem__('signature_company').__str__(), item.__dict__.__getitem__('signature_publisher').__str__(), item.__dict__.__getitem__('signature_verified').__str__())) 
        elif clioutjson == True:
            curtotal = len(result)
            curcount = 1
            if len(result) > 1:
                print('[')
            for item in result:
                # print(item)
                if curcount < curtotal:
                    print(json.dumps(item.__dict__).replace('\\\\','\\'), end=",")
                    curtotal += 1
                else:
                    print(json.dumps(item.__dict__).replace('\\\\', '\\'))
            if len(result) > 1:
                print(']')
        elif clioutyaml == True:
            for item in result:
                print('---')
                print(yaml.dump(item.__dict__).replace('\\\\','\\').strip())
        else:
            print(result)
else:
    ModHelp()
#endregion
