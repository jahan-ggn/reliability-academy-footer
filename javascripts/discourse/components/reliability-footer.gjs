import Component from "@glimmer/component";
// eslint-disable-next-line discourse/deprecated-imports
import { htmlSafe } from "@ember/template";
// eslint-disable-next-line discourse/deprecated-imports
import concatClass from "discourse/helpers/concat-class";
import { eq } from "discourse/truth-helpers";

export default class ReliabilityFooter extends Component {
  get navLinks() {
    return settings.nav_links || [];
  }

  get socialLinks() {
    return settings.social_links || [];
  }

  get hasBackgroundImage() {
    return settings.background_image && settings.background_image.length > 0;
  }

  get contactEmailHref() {
    return `mailto:${settings.contact_email}`;
  }

  get footerStyle() {
    if (this.hasBackgroundImage) {
      return htmlSafe(`background-image: url(${settings.background_image})`);
    }
    return null;
  }

  <template>
    {{#if @showFooter}}
      <footer
        class={{concatClass
          "ra-footer"
          (if this.hasBackgroundImage "--has-bg")
        }}
        style={{this.footerStyle}}
      >
        <div class="ra-footer__container">
          <div class="ra-footer__left">
            {{#if settings.logo}}
              <a class="ra-footer__logo-link" href={{settings.logo_link}}>
                <img
                  class="ra-footer__logo"
                  src={{settings.logo}}
                  alt="R2 Reliability"
                  loading="lazy"
                />
              </a>
            {{/if}}

            {{#if this.navLinks.length}}
              <ul class="ra-footer__nav">
                {{#each this.navLinks as |link|}}
                  <li class="ra-footer__nav-item">
                    <a
                      href={{link.url}}
                      class="ra-footer__nav-link"
                    >{{link.text}}</a>
                  </li>
                {{/each}}
              </ul>
            {{/if}}

            {{#if settings.copyright_text}}
              <p class="ra-footer__copyright">{{settings.copyright_text}}</p>
            {{/if}}
          </div>

          <div class="ra-footer__right">
            {{#if this.socialLinks.length}}
              <ul class="ra-footer__social">
                {{#each this.socialLinks as |link|}}
                  <li class="ra-footer__social-item">
                    <a
                      href={{link.url}}
                      target={{link.target}}
                      rel={{if (eq link.target "_blank") "noopener noreferrer"}}
                      class="ra-footer__social-link"
                      aria-label={{link.text}}
                    >
                      <img
                        src={{link.icon}}
                        alt={{link.text}}
                        loading="lazy"
                        class="ra-footer__social-icon"
                      />
                    </a>
                  </li>
                {{/each}}
              </ul>
            {{/if}}
            {{#if settings.contact_email}}
              <p class="ra-footer__contact">
                Contact us at
                <a href={{this.contactEmailHref}}>{{settings.contact_email}}</a>
              </p>
            {{/if}}
          </div>
        </div>
      </footer>
    {{/if}}
  </template>
}
