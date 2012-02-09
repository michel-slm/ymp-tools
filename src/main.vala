/* GTK+ Vala Sample Code */
using GLib;
using Gtk;
using Xml;

public errordomain YMPErrorType {
	NO_METAPACKAGE,
	NO_GROUP,
	DUPLICATES,
	UNKNOWN,
	INCOMPLETE,
}

public void trace (string message) {
        #if DEBUG
        stdout.printf (message);
        #endif
}

public class YMPInstaller : Window {
	construct {
		title = "One-click installer";
		create_widgets ();
	}

	public void create_widgets () {
		destroy += Gtk.main_quit;

		var button = new Button.with_label ("Hello World");
		button.clicked += btn => {
			title = btn.label;
		};

		add (button);
	}

	private static void parse_ymp (string path) {
		Xml.Doc* doc = Parser.parse_file (path);
		if (doc == null) {
			stderr.printf ("File '%s' not found or cannot be parsed", path);
			return;
		}
		
		try {
			// Get the root node
			Xml.Node* metapackage = doc->get_root_element ();
			if (metapackage == null || metapackage->name != "metapackage") {
				throw new YMPErrorType.NO_METAPACKAGE ("File '%s' is not a metapackage", path);
			}

			Xml.Node* group = metapackage->first_element_child();
			if (group == null || group->name != "group") {
				throw new YMPErrorType.NO_GROUP ("Cannot get group node");
			}

			Xml.Node* repos = null, software = null;

			for (Xml.Node* iter = group->children; iter != null; iter = iter->next) {
				if (iter->name == "repositories") {
					if (repos == null) repos = iter;
					else throw new YMPErrorType.DUPLICATES ("Repositories defined twice");
				} else if (iter->name == "software") {
					if (software == null) software = iter;
					else throw new YMPErrorType.DUPLICATES ("Software defined twice");
				} else if (iter->name == "text") {
					/* skip */
				} else {
					throw new YMPErrorType.UNKNOWN ("Unknown node: '%s' in group", iter->name);
				}
			}

			if (repos != null) {
				for (Xml.Node* repo = repos->children; repo != null; repo = repo->next) {
					if (repo->name == "repository") {
						process_repo(repo);
					} else if (repo->name == "text") {
						/* skip */
					} else {
						throw new YMPErrorType.UNKNOWN (
							"Unknown node: '%s' in repositories", repo->name
						);
					}
				}
			}

			if (software == null) {
				throw new YMPErrorType.INCOMPLETE (
					"Incomplete metapackage: no software listed to be installed"
				);
			}
			process_software(software);		
		} catch (YMPErrorType e) {
			stderr.printf (e.message);
		} finally {
			delete doc;
		}
	}

	private static string process_item (Xml.Node* item) throws YMPErrorType {
		string name = null, summary = null, description = null;
		for (Xml.Node* iter = item->children; iter != null; iter = iter->next) {
			if (iter->name == "name") {
				if (name == null) name = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Item name defined twice");
			} else if (iter->name == "summary") {
				if (summary == null) summary = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Item summary defined twice");
			} else if (iter->name == "description") {
				if (description == null) description = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Item description defined twice");
			} else if (iter->name == "text") {
				/* skip */
			} else {
				throw new YMPErrorType.UNKNOWN ("Unknown node: '%s' in group", iter->name);
			}
		}
		stdout.printf ("package=%s\n", name);
		stdout.printf ("summary=%s\n", summary);
		stdout.printf("description=%s\n", description);
		stdout.printf("\n");
		return name;
	}

	private static void process_repo (Xml.Node* repo) throws YMPErrorType {
		string name = null, summary = null, description = null, url = null;
		bool recommended = (repo->get_prop ("recommended") == "true") ? true : false;
		for (Xml.Node* iter = repo->children; iter != null; iter = iter->next) {
			if (iter->name == "name") {
				if (name == null) name = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Repo name defined twice");
			} else if (iter->name == "summary") {
				if (summary == null) summary = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Repo summary defined twice");
			} else if (iter->name == "description") {
				if (description == null) description = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Repo description defined twice");
			} else if (iter->name == "url") {
				if (url == null) url = iter->get_content ();
				else throw new YMPErrorType.DUPLICATES ("Repo URL defined twice");
			} else if (iter->name == "text") {
				/* skip */
			} else {
				throw new YMPErrorType.UNKNOWN ("Unknown node: '%s' in group", iter->name);
			}
		}
		stdout.printf ("[%s]\n", name);
		stdout.printf ("name=%s\n", summary);
		stdout.printf("baseurl=%s\n", url);
		stdout.printf("enabled=%d\n", recommended ? 1 : 0);
		stdout.printf("\n");
	}

	private static void process_software (Xml.Node* software) throws YMPErrorType {
		string cmd = "yum install";
		for (Xml.Node* item = software->children; item != null; item = item->next) {
			if (item->name == "item") {
				cmd += " " + process_item (item);
			} else if (item->name == "text") {
				/* skip */
			} else {
				throw new YMPErrorType.UNKNOWN ("Unknown node: '%s' in software", item->name);
			}
		}
		stdout.printf("%s\n", cmd);
	}

	static int main (string[] args) {
		// Gtk.init (ref args);

		stdout.printf ("One-click installer\n");

		// var installer = new YMPInstaller ();
		// installer.show_all ();

		// var loop = new MainLoop();

		// var foo = new Foo(loop);
		// foo.an_event.connect(() => {stdout.printf("Foo"); stdout.flush(); return false;});

		// var bar = new Bar(loop);
		// bar.an_event.connect(() => {stdout.printf("Bar\n"); loop.quit(); return false;});

		// loop.run();


		// Gtk.main ();

		if (args.length != 2) {
			stderr.printf ("Usage: %s a-ymp-file", args[0]);
			return 1;
		}
		parse_ymp (args[1]);
		return 0;
	}
}

