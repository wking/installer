package openstack

import (
	"context"
	"os"

	"github.com/openshift/installer/pkg/installerassets"
	"github.com/pkg/errors"
	survey "gopkg.in/AlecAivazis/survey.v1"
)

func getRegion(ctx context.Context) ([]byte, error) {
	value := os.Getenv("OPENSHIFT_INSTALL_OPENSTACK_REGION")
	if value != "" {
		//FIXME(shardy) add some validation here
		return []byte(value), nil
	}

	question := &survey.Question{
		Prompt: &survey.Input{
			Message: "Region",
			Help:    "The OpenStack region to be used for installation.",
			Default: "regionOne",
		},
		Validate: survey.ComposeValidators(survey.Required, func(ans interface{}) error {
			//FIXME(shardy) add some validation here
			return nil
		}),
	}

	var response string
	err := survey.Ask([]*survey.Question{question}, &response)
	if err != nil {
		return nil, errors.Wrap(err, "ask")
	}

	return []byte(response), nil
}

func init() {
	installerassets.Defaults["openstack/region"] = getRegion
}
