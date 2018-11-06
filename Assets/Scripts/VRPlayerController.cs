using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using OmniVirt;

public class VRPlayerController : MonoBehaviour {

	public Button PlayButton;
	public GameObject Crate;
	public Image LogoImage;

	VRPlayer vrPlayer;

	// Use this for initialization
	void Start () {
		Debug.Log ("OmniVirt SDK Version v" + OmniVirt.SDK.SDK_VERSION);

		// Bind PlayButton's Click Event with OnPlayButtonClicked
		PlayButton.onClick.AddListener (OnPlayButtonClicked);
	}

	void OnPlayButtonClicked() {
		// Disable Play Button
		PlayButton.interactable = false;

		// Create VR Player instance
		vrPlayer = new VRPlayer ();

		// Register Callback for Video Playing Completion Event
		vrPlayer.OnVideoEnd += OnVRPlayerEnded;
		vrPlayer.OnUnloaded += OnVRPlayerUnloaded;

		// Play
		vrPlayer.LoadAndPlay (24, false);
	}

	/*************************
	 * Callback for VR Player
	 *************************/

	// Video Playing Completion Event
	void OnVRPlayerEnded() {
		// Close VR Player
		CloseVRPlayer ();

		// Re-enable Play Button
		PlayButton.interactable = true;
	}

	// VR Player Unloaded Event
	void OnVRPlayerUnloaded() {
		vrPlayer = null;
		
		// Re-enable Play Button
		PlayButton.interactable = true;
	}

	// Update is called once per frame
	void Update () {
		// Rotate Crate
		Crate.transform.Rotate (1, 1.5f, 0.5f);

		// Handle Back Button
		if (Input.GetKeyDown(KeyCode.Escape)) {
			if (vrPlayer != null)
				return;
			Application.Quit ();
		}
	}

	void CloseVRPlayer() {
		// Close VR Player
		if (vrPlayer != null) {
			vrPlayer.Unload ();
			vrPlayer = null;
		}
	}

}
